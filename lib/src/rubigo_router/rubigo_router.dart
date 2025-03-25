import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/last_page_popped_exception.dart';
import 'package:rubigo_router/src/rubigo_router/stack_manager/rubigo_stack_manager.dart';

/// A router based on [RubigoScreen]'s.
/// * Use the init function to initialize your app. For example to initialize
/// all services that your app uses. When the initialization is done, you must
/// return the first screen of the app.
/// * During the initialisation a splashscreen is shown.
/// * Use the navigation functions in [RubigoRouter] when you want to
/// change the stack.
/// * Use the navigation functions in [RubigoRouter.ui] when you want to change
/// the stack, but the action is initiated by the user, for example by pressing
/// a button. The call is ignored when the app is busy. See [RubigoBusyService].
/// * During navigation, the app is automatically marked as busy. You can set
/// the app busy by wrapping parts of your code in a
/// [RubigoBusyService.busyWrapper].
/// ```dart
/// void main() {
///   // Create a RubigoRouter for the set of screens defined by the Screens enum.
///   // Pass it all available screens and the one to use as a splash screen.
///   final rubigoRouter = RubigoRouter<Screens>(
///     availableScreens: availableScreens,
///     splashScreenId: Screens.splashScreen,
///   );
///
///   // Add the router to the holder, so we have access to the router from all
///   // parts of our app. This is not needed if you use RubigoScreenMixin or
///   // RubigoControllerMixin
///   holder.add(rubigoRouter);
///
///   // Create a RubigoRouterDelegate.
///   final routerDelegate = RubigoRouterDelegate(
///     rubigoRouter: rubigoRouter,
///   );
///
///   // Calling init is mandatory. While init executes, the splashScreen is shown.
///   // Init returns the first screen to show to the user.
///   // This callback can be used to initialize the application.For this to work,
///   // the splashScreen should not accept any user interaction.
///   Future<Screens> initAndGetFirstScreen() async {
///     await Future<void>.delayed(const Duration(seconds: 2));
///     return Screens.s110;
///   }
///
///   runApp(
///     // Here we use a RubigoMaterialApp to reduce the complexity of this example.
///     // You might want to replicate the contents of the RubigoMaterialApp and
///     // adjust it to your needs for more complex scenarios.
///     RubigoMaterialApp(
///       initAndGetFirstScreen: initAndGetFirstScreen,
///       routerDelegate: routerDelegate,
///       backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
///     ),
///   );
/// }
/// ```
class RubigoRouter<SCREEN_ID extends Object> with ChangeNotifier {
  /// Creates a [RubigoRouter]
  factory RubigoRouter({
    required GetRubigoScreen<SCREEN_ID> getRubigoScreen,
    required SCREEN_ID splashScreenId,
    RubigoBusyService? rubigoBusyService,
    LogNavigation? logNavigation,
    RubigoStackManager<SCREEN_ID>? rubigoStackManager,
    Future<void> Function()? onLastPagePopped,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final stackManager = rubigoStackManager ??
        RubigoStackManager(
          [splashScreenId],
          getRubigoScreen,
          logNavigation ?? _defaultLogNavigation,
        );
    return RubigoRouter._(
      getRubigoScreen: getRubigoScreen,
      rubigoBusyService: rubigoBusyService ?? RubigoBusyService(),
      logNavigation: logNavigation ?? _defaultLogNavigation,
      rubigoStackManager: stackManager,
      onLastPagePopped: onLastPagePopped ?? _defaultOnLastPagePopped,
      navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
    );
  }

  RubigoRouter._({
    required GetRubigoScreen<SCREEN_ID> getRubigoScreen,
    required RubigoBusyService rubigoBusyService,
    required LogNavigation logNavigation,
    required RubigoStackManager<SCREEN_ID> rubigoStackManager,
    required Future<void> Function() onLastPagePopped,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _getRubigoScreen = getRubigoScreen,
        _busyService = rubigoBusyService,
        _logNavigation = logNavigation,
        _onLastPagePopped = onLastPagePopped,
        _navigatorKey = navigatorKey,
        _rubigoStackManager = rubigoStackManager {
    ///Listen to updates and notify our listener, the RouterDelegate
    _rubigoStackManager.addListener(notifyListeners);
  }

  //region Public
  /// Pass a function that handles your app initialisation (like setting
  /// up dependency-injection etc). When ready, return the first screen of the
  /// app.
  Future<void> init({
    required Future<SCREEN_ID> Function() initAndGetFirstScreen,
  }) async {
    await _logNavigation('RubigoRouter.init() called.');
    final firstScreen = await initAndGetFirstScreen();
    await _logNavigation(
      'RubigoRouter.init() ended. First screen will be '
      '${getName(firstScreen)}.',
    );
    _isInitialized = true;
    await replaceStack([firstScreen]);
  }

  /// This parameter contains the busy service. If none is
  /// specified, it will default to an instance of [RubigoBusyService].
  RubigoBusyService get busyService => _busyService;

  /// This function can be used to log all that is related to navigation
  LogNavigation get logNavigation => _logNavigation;

  /// Returns true if the app is currently navigating.
  bool get isNavigating => _rubigoStackManager.isNavigating;

  /// Unregisters and registers a callback function to be executed immediately
  /// *after* the current navigation completes.
  ///
  /// This is useful for scenarios where you receive an asynchronous event
  /// (for example a user authentication status change)
  /// that requires immediate action, but you need to wait for any ongoing
  /// navigation to finish before starting new navigation actions.
  ///
  /// **Important considerations:**
  ///
  /// *   **Single Callback:** Only one callback can be registered at a time.
  /// Registering a new callback will overwrite any previously registered
  /// callback.
  /// *   **Unregistering:** To remove a registered callback, pass `null` as the
  /// argument.
  /// *   **Automatic Unregistration:** The callback is automatically
  /// unregistered immediately after it has been executed.
  void registerPostNavigationCallback(PostNavigationCallback? callback) {
    _rubigoStackManager.registerPostNavigationCallback(callback);
  }

  /// Returns true if the router is initialized.
  /// This means the app is up and running.
  bool get isInitialized => _isInitialized;

  //endregion

  //region Private

  final GetRubigoScreen<SCREEN_ID> _getRubigoScreen;

  final RubigoBusyService _busyService;

  final LogNavigation _logNavigation;

  late final RubigoStackManager<SCREEN_ID> _rubigoStackManager;

  final Future<void> Function() _onLastPagePopped;

  final GlobalKey<NavigatorState> _navigatorKey;

  var _isInitialized = false;

  //endregion

  //region Properties to pass to Flutter's Navigator
  /// Pass this key to [Navigator.key].
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Pass this property to [Navigator.pages]. Use an extension like
  /// [ExtensionOnRubigoScreen.toMaterialPage] or
  /// [ExtensionOnRubigoScreen.toCupertinoPage] to convert each item to a
  /// [Page] object.
  /// When this object calls [notifyListeners], the [Navigator] rebuilds and
  /// gets a fresh list of pages from this router.
  ListOfRubigoScreens<SCREEN_ID> get screens =>
      _rubigoStackManager.screens.map(_getRubigoScreen).toList();

  /// Pass this property to [Navigator.onDidRemovePage].
  void onDidRemovePage(Page<Object?> page) {
    final pageKey = page.key;
    if (pageKey == null) {
      final txt =
          'PANIC: page.key must be of type ValueKey<$SCREEN_ID>, but found '
          'null.';
      unawaited(_logNavigation(txt));
      throw UnsupportedError(txt);
    }
    if (pageKey is! ValueKey<SCREEN_ID>) {
      final txt =
          'PANIC: page.key must be of type ValueKey<$SCREEN_ID>, but found '
          '${pageKey.runtimeType}.';
      unawaited(_logNavigation(txt));
      throw UnsupportedError(txt);
    }
    final removedScreenId = pageKey.value;
    final lastScreenId = _rubigoStackManager.screens.last;
    if (removedScreenId != lastScreenId) {
      // With this new event, we also receive this event when pages are removed
      // programmatically from the stack. Here onDidRemovePage was (probably)
      // initiated by the business logic, as the last page on the stack is not
      // the one that got removed. In this case the screenStack is already
      // valid.
      unawaited(
        _logNavigation(
          'onDidRemovePage(${getName(removedScreenId)}) called. Last page is '
          '${getName(lastScreenId)}, ignoring.',
        ),
      );
      return;
    }

    // handle the back event.
    unawaited(
      _logNavigation(
        'onDidRemovePage(${getName(removedScreenId)}) called.',
      ),
    );

    Future<void> callPop() async {
      // This function calls ui.pop and keeps track if updateScreens is being
      // called, while executing ui.pop().
      var updateScreensIsCalled = false;
      void updateScreenCallback() => updateScreensIsCalled = true;
      _rubigoStackManager.updateScreensCallBack.add(updateScreenCallback);
      await ui.pop();
      if (!updateScreensIsCalled) {
        await _rubigoStackManager.updateScreens();
      }
      _rubigoStackManager.updateScreensCallBack.remove(updateScreenCallback);
    }

    final navState = _navigatorKey.currentState;
    if (navState == null) {
      // We cannot continue if we cannot access Flutter's navigator.
      return;
    }

    // Remove the last page, so the screens is the same as Flutter expects.
    // Just in case the widget tree rebuilds for some reason.
    // Note: this will not inform the listeners, this is intended behavior.
    screens.removeLast();

    Future<void> gestureCallback() async {
      final inProgress = navState.userGestureInProgress;
      if (!inProgress) {
        navState.userGestureInProgressNotifier.removeListener(gestureCallback);
        await callPop();
      }
    }

    if (navState.userGestureInProgress) {
      // We have to wait for the gesture to finish. Otherwise pageless routes,
      // that might have been added in mayPop (like showDialog), are popped
      // together with the page. That is how Navigator 2.0 works, nothing we
      // can about that. Wait for the gesture to complete and the perform the
      // pop().
      navState.userGestureInProgressNotifier.addListener(gestureCallback);
      return;
    }

    final warningText = '''
RubigoRouter warning.
"onDidRemovePage called" for ${getName(removedScreenId)}, but the source was not a userGesture. 
The cause is most likely that Navigator.maybePop(context) was (indirectly) called.
This can happen when:
- A regular BackButton was used to pop this page. Solution: Use a rubigoBackButton in the AppBar.
- The MaterialApp.backButtonDispatcher was not a RubigoRootBackButtonDispatcher.
- The pop was not caught by a RubigoBackGesture widget.
''';
    unawaited(_logNavigation(warningText));

    // This is a workaround for the following exception:
    // Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 4931 pos 12: '!_debugLocked': is not true.
    // Which can happen if a showDialog (or other pageless route) was pushed in
    // the mayPop callback. This is a workaround and should not end up in
    // production. Read the warning here above.
    Future.delayed(Duration.zero, callPop);
  }

  //endregion

  // region Navigation functions
  /// Pops the current screen from the stack
  Future<void> pop() async {
    await _logNavigation('pop() called.');
    try {
      await busyService.busyWrapper(_rubigoStackManager.pop);
    } on LastPagePoppedException catch (e) {
      await _logNavigation(e.message);
      await _onLastPagePopped();
    }
  }

  /// Pop directly to the screen with [screenId].
  Future<void> popTo(SCREEN_ID screenId) async {
    await _logNavigation('popTo(${getName(screenId)}) called.');
    await busyService.busyWrapper(() => _rubigoStackManager.popTo(screenId));
  }

  /// Push screen with [screenId] on the stack.
  Future<void> push(SCREEN_ID screenId) async {
    await _logNavigation('push(${getName(screenId)}) called.');
    await busyService.busyWrapper(() => _rubigoStackManager.push(screenId));
  }

  /// Replace the current screen stack with another screen stack.
  Future<void> replaceStack(List<SCREEN_ID> screens) async {
    await _logNavigation(
      'replaceStack(${screens.map(getName).join('→')}) called.',
    );
    await busyService.busyWrapper(
      () => _rubigoStackManager.replaceStack(screens),
    );
  }

  /// Remove the screen with [screenId] silently from the stack.
  Future<void> remove(SCREEN_ID screenId) async {
    await _logNavigation('remove(${getName(screenId)}) called.');
    await _rubigoStackManager.remove(screenId);
  }

  // endregion

  //region User initiated (ui) navigation functions
  /// {@template Ui}
  /// Use these navigation functions everywhere when the origin is user
  /// initiated, like on button presses. These calls will automatically be
  /// ignored if the app is busy.
  /// {@endtemplate}
  late final Ui<SCREEN_ID> ui = Ui<SCREEN_ID>(
    pop: () async {
      // First, take notice if the app is busy while this function was called.
      final isBusy = busyService.isBusy;
      // Second, set isBusy to  true.
      await busyService.busyWrapper(
        () async {
          if (isBusy) {
            await _logNavigation(
              'Pop was called by the user, but the app is busy.',
            );
            return;
          }
          // We have to ask the page if we may pop.
          final bool mayPop;
          // Get the page to pop from the stack.
          final screenId = _rubigoStackManager.screenStack.last;
          // Find the controller
          final controller = _getRubigoScreen(screenId).getController();
          if (controller is RubigoControllerMixin<SCREEN_ID>) {
            // If the controller implements RubigoControllerMixin, call mayPop.
            await _logNavigation('Call mayPop().');
            mayPop = await controller.mayPop();
            await _logNavigation('The controller returned "$mayPop"');
          } else {
            // Otherwise the screen may always be popped
            mayPop = true;
            await _logNavigation(
                'The controller is not a RubigoControllerMixin, '
                'mayPop is always "true"');
          }
          if (mayPop) {
            await pop();
          }
        },
      );
    },
    popTo: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation(
            'PopTo(${getName(screenId)}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await popTo(screenId);
    },
    push: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation(
            'Push(${getName(screenId)}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await push(screenId);
    },
    replaceStack: (List<SCREEN_ID> screens) async {
      if (busyService.isBusy) {
        await _logNavigation(
            'replaceStack(${screens.breadCrumbs()}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await replaceStack(screens);
    },
    remove: (SCREEN_ID screenId) async {
      if (busyService.isBusy) {
        await _logNavigation(
            'remove(${getName(screenId)}) was called by the user, '
            'but the app is busy.');
        return;
      }
      await remove(screenId);
    },
  );
//endregion
}

/// This class groups ui navigation functions together.
/// {@macro Ui}
class Ui<SCREEN_ID extends Object> {
  /// Creates a [Ui] class
  Ui({
    required this.pop,
    required this.popTo,
    required this.push,
    required this.replaceStack,
    required this.remove,
  });

  /// ui.pop()
  final Future<void> Function() pop;

  /// ui.popTo
  final Future<void> Function(SCREEN_ID screenId) popTo;

  /// ui.push
  final Future<void> Function(SCREEN_ID screenId) push;

  /// ui.replaceStack
  final Future<void> Function(List<SCREEN_ID> screens) replaceStack;

  /// ui.remove
  final Future<void> Function(SCREEN_ID screenId) remove;
}

Future<void> _defaultLogNavigation(String message) async {
  if (kDebugMode) {
    debugPrint(message);
  }
}

Future<void> _defaultOnLastPagePopped() async {
  await SystemNavigator.pop();
}
