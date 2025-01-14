import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/stack_manager/navigation_events/navigation_events.dart';

/// This manages the screen stack. It provides functions to manipulate the stack
/// and it fires events like [RubigoControllerMixin.onTop] and
/// [RubigoControllerMixin.willShow]
class RubigoStackManager<SCREEN_ID extends Enum> {
  /// Creates a RubigoStackManager
  RubigoStackManager(
    this._screenStack,
    this._availableScreens,
    this._logNavigation,
  ) : screens = ValueNotifier<List<RubigoScreen<SCREEN_ID>>>([..._screenStack]);

  // This is the actual screen stack, which can have other contents than
  // 'screens' when the app is busy navigating and the stack is not stable yet.
  ListOfRubigoScreens<SCREEN_ID> _screenStack;

  // This is a list of all available screens.
  final ListOfRubigoScreens<SCREEN_ID> _availableScreens;

  // This function is called for logging purposes.
  final LogNavigation _logNavigation;

  /// The current stable version of the screen stack. It is only updated
  /// when navigation is complete.
  final ValueNotifier<ListOfRubigoScreens<SCREEN_ID>> screens;

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
  void remove(SCREEN_ID screenId) {
    final index = _screenStack.indexWhere((e) => e.screenId == screenId);
    if (index == -1) {
      throw UnsupportedError(
        'Developer: You can only remove screens that exist on the stack '
        '(${screenId.name} not found).',
      );
    }
    _screenStack.removeAt(index);
    _updateScreens();
  }

  //region _navigate
  bool _inWillShow = false;
  int _eventCounter = 0;

  late RubigoChangeInfo<SCREEN_ID> _changeInfo;

  Future<void> _navigate(NavigationEvent<SCREEN_ID> navigationEvent) async {
    if (_inWillShow) {
      throw UnsupportedError(
        'Developer: you may not Push or Pop in the willShow method.',
      );
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
    }

    if (_eventCounter == 0) {
      // When the eventCounter is 0, we know that no navigation functions have
      // been called in the last onTop event.
      final controller = _screenStack.last.getController();
      if (controller is RubigoControllerMixin) {
        _inWillShow = true;
        await controller.willShow(_changeInfo);
        _inWillShow = false;
      }
      _updateScreens();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (controller is RubigoControllerMixin) {
        await controller.isShown(_changeInfo);
      }
    }
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _push(
    Push<SCREEN_ID> navigationEvent,
  ) async {
    final previousScreen = _screenStack.last;
    final newScreen = _availableScreens.find(navigationEvent.screenId);
    _screenStack.add(newScreen);
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo<SCREEN_ID>(
      EventType.push,
      previousScreen.screenId,
      _screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  Future<RubigoChangeInfo<SCREEN_ID>> _pop() async {
    if (_screenStack.length < 2) {
      throw UnsupportedError(
        'Developer: Pop was called on the last screen. The screen stack '
        'may not be empty.',
      );
    }
    final previousScreen = _screenStack.last;
    _screenStack.removeLast();
    final newScreen = _screenStack.last;
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.pop,
      previousScreen.screenId,
      _screenStack.toListOfScreenId(),
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
    final previousScreen = _screenStack.last;
    final index = _screenStack.indexWhere(
      (e) => e.screenId == navigationEvent.screenId,
    );
    // If not found, or the topmost one
    if (index == -1 || index == _screenStack.length - 1) {
      throw UnsupportedError(
        'Developer: With popTo, you tried to navigate to '
        '${navigationEvent.screenId.name}, which was not on the stack.',
      );
    }
    _screenStack.removeRange(index + 1, _screenStack.length);

    final newScreen = _screenStack.last;
    final controller = newScreen.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.popTo,
      previousScreen.screenId,
      _screenStack.toListOfScreenId(),
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
    final previousScreen = _screenStack.last;
    _screenStack = navigationEvent.screenStack.toListOfRubigoScreen(
      _availableScreens,
    );
    final controller = _screenStack.last.getController();
    final changeInfo = RubigoChangeInfo(
      EventType.replaceStack,
      previousScreen.screenId,
      _screenStack.toListOfScreenId(),
    );
    if (controller is RubigoControllerMixin) {
      _eventCounter++;
      await controller.onTop(changeInfo);
      _eventCounter--;
    }
    return changeInfo;
  }

  //endregion navigate

  void _updateScreens() {
    screens.value = [..._screenStack];
    unawaited(_logNavigation(screens.value.toListOfScreenId().breadCrumbs()));
  }
}
