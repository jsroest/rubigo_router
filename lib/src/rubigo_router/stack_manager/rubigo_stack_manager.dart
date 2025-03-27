import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/last_page_popped_exception.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/navigation_events.dart';

/// This class manages the screen stack. It provides functions to manipulate the
/// stack and it fires events like [RubigoControllerMixin.onTop] and
/// [RubigoControllerMixin.willShow].
class RubigoStackManager<SCREEN_ID extends Object> with ChangeNotifier {
  /// Creates a [RubigoStackManager]
  RubigoStackManager(
    this.screenStack,
    this._screenProvider,
    this._logNavigation,
  ) : _screens = [...screenStack];

  /// This is the actual screen stack, which can have other contents than
  /// [screens] when the app is busy navigating and the stack is not stable yet.
  List<SCREEN_ID> screenStack;

  // This is a function that can be called after navigation has taken place.
  PostNavigationCallback? _postNavigationCallback;

  // This is a list of all available screens.
  final ScreenProvider<SCREEN_ID> _screenProvider;

  // This function is called for logging purposes.
  final LogNavigation _logNavigation;

  // The backing variable for screens
  List<SCREEN_ID> _screens;

  /// The current stable version of the screen stack. It is only updated
  /// when navigation is complete.
  List<SCREEN_ID> get screens => _screens;

  /// Pops a screen from the stack. This call can generate more navigation
  /// calls.
  Future<void> pop() => _navigate(Pop<SCREEN_ID>());

  /// Pop directly to a specific screen on the stack. This call can generate
  /// more navigation calls.
  Future<void> popTo(SCREEN_ID screenId) => _navigate(PopTo(screenId));

  /// Push a specific screen on the stack. This call can generate more
  /// navigation calls.
  Future<void> push(SCREEN_ID screenId) => _navigate(Push(screenId));

  /// Replace the stack with a new list of screens. This call can generate more
  /// navigation calls.
  Future<void> replaceStack(List<SCREEN_ID> screens) =>
      _navigate(ReplaceStack(screens));

  /// Remove a screen silently from the stack. This call can not generate more
  /// navigation calls, because it does not fire any events.
  Future<void> remove(SCREEN_ID screenId) => _navigate(Remove(screenId));

  /// Returns true if the app is currently navigating.
  bool get isNavigating => _isNavigating;

  //region _private
  bool _isNavigating = false;
  bool _inWillShow = false;
  bool _inRemovedFromStack = false;
  int _eventCounter = 0;

  RubigoChangeInfo<SCREEN_ID>? _changeInfo;

  Future<void> _navigate(NavigationEvent<SCREEN_ID> navigationEvent) async {
    _isNavigating = true;
    if (_eventCounter == 0) {
      _changeInfo = null;
    }
    if (_inWillShow) {
      const txt = 'Developer: you may not call push, pop, popTo, replaceStack '
          'or remove in the willShow method.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    if (_inRemovedFromStack) {
      const txt = 'Developer: you may not call push, pop, popTo, replaceStack '
          'or remove in the removedFromStack method.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    switch (navigationEvent) {
      case Push<SCREEN_ID>():
        _changeInfo = await _push(navigationEvent);
      case Pop():
        _changeInfo = await _pop();
      case PopTo<SCREEN_ID>():
        _changeInfo = await _popTo(navigationEvent);
      case ReplaceStack<SCREEN_ID>():
        _changeInfo = await _replaceStack(navigationEvent);
      case Remove<SCREEN_ID>():
        await _remove(navigationEvent);
    }

    if (_eventCounter == 0) {
      // When the eventCounter is 0, we know that no navigation functions have
      // been called in the last onTop event.
      final tmpChangeInfo = _changeInfo;
      if (tmpChangeInfo != null) {
        final controller = _screenProvider(screenStack.last).controller();
        if (controller is RubigoControllerMixin) {
          _inWillShow = true;
          await controller.willShow(tmpChangeInfo);
          _inWillShow = false;
        }
      }
      await updateScreens();
      _isNavigating = false;
      final callBack = _postNavigationCallback;
      if (callBack != null) {
        _postNavigationCallback = null;
        await callBack();
      }
    }
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _push(
    Push<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreenId = screenStack.last;
    screenStack.add(navigationEvent.screenId);
    final controller = _screenProvider(screenStack.last).controller();
    final changeInfo = RubigoChangeInfo<SCREEN_ID>(
      EventType.push,
      previousScreenId,
      screenStack,
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _pop() async {
    if (screenStack.length < 2) {
      throw LastPagePoppedException('The last page is popped.');
    }
    final previousScreenId = screenStack.last;
    screenStack.removeLast();
    final controller = _screenProvider(screenStack.last).controller();
    final changeInfo = RubigoChangeInfo(
      EventType.pop,
      previousScreenId,
      screenStack,
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _popTo(
    PopTo<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreenId = screenStack.last;
    final index = screenStack.indexWhere(
      (screenId) => screenId == navigationEvent.screenId,
    );
    // If not found, or the topmost one
    if (index == -1 || index == screenStack.length - 1) {
      final txt = 'Developer: With popTo, you tried to navigate to '
          '${getName(navigationEvent.screenId)}, which was not below this '
          'screen on the stack.';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    screenStack.removeRange(index + 1, screenStack.length);

    final controller = _screenProvider(screenStack.last).controller();
    final changeInfo = RubigoChangeInfo(
      EventType.popTo,
      previousScreenId,
      screenStack,
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _replaceStack(
    ReplaceStack<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreenId = screenStack.last;
    screenStack = navigationEvent.screenStack;
    final controller = _screenProvider(screenStack.last).controller();
    final changeInfo = RubigoChangeInfo(
      EventType.replaceStack,
      previousScreenId,
      screenStack,
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<void> _remove(
    Remove<SCREEN_ID> navigationEvent,
  ) async {
    final index = screenStack.indexWhere(
      (screenId) => screenId == navigationEvent.screenId,
    );
    if (index == -1) {
      final txt = 'Developer: You can only remove screens that exist on the '
          'stack (${getName(navigationEvent.screenId)} not found).';
      await _logNavigation(txt);
      throw UnsupportedError(txt);
    }
    screenStack.removeAt(index);
  }

  //endregion private

  /// Force Flutters [Navigator] to match our list of [screens].
  Future<void> updateScreens() async {
    final oldScreenSet = screens.toSet();
    final newScreenSet = screenStack.toSet();
    // The ValueNotifier always calls it's listeners when we assign an new copy
    // of the stack. Also if the contents are logically the same. In this case
    // this is what we want, specifically in case of handling onDidRemovePage.
    _screens = [...screenStack];
    await _logNavigation(
      'Screens: '
      '${screens.map(getName).join('→')}.',
    );
    notifyListeners();
    // Inform al controllers that were removed from the stack.
    for (final screenId in oldScreenSet.difference(newScreenSet)) {
      final controller = _screenProvider(screenId).controller();
      if (controller is RubigoControllerMixin<SCREEN_ID>) {
        _inRemovedFromStack = true;
        await controller.removedFromStack();
        _inRemovedFromStack = false;
      }
    }
    for (final callBack in updateScreensCallBack) {
      callBack.call();
    }
  }

  /// Register a callback in this list, if you want to be notified if the
  /// updateScreens function is called.
  final updateScreensCallBack = <VoidCallback>[];

  /// Execute this function, when the current navigation has finished.
  //ignore: use_setters_to_change_properties
  void registerPostNavigationCallback(PostNavigationCallback? callback) {
    _postNavigationCallback = callback;
  }
}
