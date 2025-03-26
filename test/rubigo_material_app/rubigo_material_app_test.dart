import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rubigo_router/rubigo_router.dart';

import '../mock_controller/mock_controller.dart';
import 'helpers/rubigo_router_observer.dart';
import 'helpers/rubigo_router_observer.mocks.dart';

void main() {
  late MockNavigatorObserver mockNavigatorObserver;
  late RubigoNavigatorObserver rubigoNavigatorObserver;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(
    () {
      logNavigation.clear();
      mockNavigatorObserver = MockNavigatorObserver();
      rubigoNavigatorObserver = RubigoNavigatorObserver<_Screens>();
      final holder = RubigoHolder();
      RubigoScreen<_Screens> screenProvider(_Screens screenId) {
        switch (screenId) {
          case _Screens.splashScreen:
            return RubigoScreen(
              screenId: _Screens.splashScreen,
              getScreenWidget: _SplashScreen.new,
              getController: () =>
                  holder.getOrCreate<_SplashController>(_SplashController.new),
              getRubigoRouter: () => rubigoRouter,
            );
          case _Screens.s100:
            return RubigoScreen(
              screenId: _Screens.s100,
              getScreenWidget: _S100Screen.new,
              getController: () =>
                  holder.getOrCreate<_S100Controller>(_S100Controller.new),
              getRubigoRouter: () => rubigoRouter,
            );
          case _Screens.s200:
            return RubigoScreen(
              screenId: _Screens.s200,
              getScreenWidget: _S200Screen.new,
              getController: () =>
                  holder.getOrCreate<_S200Controller>(_S200Controller.new),
              getRubigoRouter: () => rubigoRouter,
            );
        }
      }

      rubigoRouter = RubigoRouter(
        screenProvider: screenProvider,
        splashScreenId: _Screens.splashScreen,
        logNavigation: (message) async => logNavigation.add(message),
      );
    },
  );

  testWidgets(
    'SplashScreen to S100, with delay  in init ',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async {
            await Future<void>.delayed(const Duration(milliseconds: 200));
            return _Screens.s100;
          },
        ),
      );
      await tester.pumpAndSettle();
      verifyInOrder(
        [
          mockNavigatorObserver.navigator,
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.splashScreen);
      await tester.pump(const Duration(milliseconds: 300));
      verifyInOrder(
        [
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didRemove(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.s100);
      expect(rubigoRouter.busyService.enabled, true);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
        ],
      );
    },
  );

  testWidgets(
    'SplashScreen to S100, no delay  in init ',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      verifyInOrder(
        [
          mockNavigatorObserver.navigator,
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
          mockNavigatorObserver.didPush(any, any),
          mockNavigatorObserver.didRemove(any, any),
          mockNavigatorObserver.didChangeTop(any, any),
        ],
      );
      expect(rubigoNavigatorObserver.currentScreenId, _Screens.s100);
      expect(rubigoRouter.busyService.enabled, true);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
        ],
      );
    },
  );

  testWidgets(
    'Delayed progress indicator when busy',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () async {
          await rubigoRouter.busyService.busyWrapper(
            () async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await tester.pump();
              expect(find.byType(CircularProgressIndicator), findsNothing);
              // The delay before showing a progress indicator is
              // 300 milliseconds. Together with the 100 milliseconds, this
              // should be enough.
              await Future<void>.delayed(const Duration(milliseconds: 300));
              await tester.pump();
              expect(find.byType(CircularProgressIndicator), findsOne);
            },
          );
        },
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
        ],
      );
    },
  );

  testWidgets(
    'S100 ui.push(S200)',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 UI BackButton',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(_S100Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
          'Call mayPop().',
          'The controller returned "true"',
          'pop() called.',
          'Screens: s100.',
          'onDidRemovePage(s200) called. Last page is s100, ignoring.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 UI BackButton, when busy',
    (tester) async {
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          // This should give a warning in the console log that it could not be
          // tapped.
          // Warning: A call to tap() with finder "Found 1 widget with widget
          // matching predicate: [Tooltip("Back", dependencies:
          // [InheritedCupertinoTheme, _InheritedTheme,
          // _LocalizationsScope-[GlobalKey#6e211]], state: TooltipState#c9afe),
          // ]" derived an Offset (Offset(28.0, 28.0)) that would not hit test
          // on the specified widget. Maybe the widget is actually off-screen,
          // or another widget is obscuring it, or the widget cannot receive
          // pointer events.
          await tester.pageBack();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(find.byType(_S100Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
          'RubigoRootBackButtonDispatcher.didPopRoute() called.',
          'Current route is Page().',
          'Call mayPop().',
          'The controller returned "true"',
          'pop() called.',
          'Screens: s100.',
          'onDidRemovePage(s200) called. Last page is s100, ignoring.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton, when busy',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        await rubigoRouter.busyService.busyWrapper(() async {
          await tester.pump();
          //This should give a warning in the log that it could not be tapped.
          await backButtonDispatcher.didPopRoute();
        });
      });
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
          'RubigoRootBackButtonDispatcher.didPopRoute() called.',
          'Current route is Page().',
          'Pop was called by the user, but the app is busy.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 Hardware BackButton, when dialog shows',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(_testShowDialog(rubigoRouter));
      });
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.runAsync(() async => backButtonDispatcher.didPopRoute());
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
          'RubigoRootBackButtonDispatcher.didPopRoute() called.',
          'Current route is a pageless route. super.didPopRoute() called.',
        ],
      );
    },
  );

  testWidgets(
    'S100-S200 Dialog shows, press button',
    (tester) async {
      final backButtonDispatcher = RubigoRootBackButtonDispatcher(rubigoRouter);
      await tester.pumpWidget(
        RubigoMaterialApp(
          backButtonDispatcher: backButtonDispatcher,
          routerDelegate: RubigoRouterDelegate(
            observers: [
              mockNavigatorObserver,
              rubigoNavigatorObserver,
            ],
            rubigoRouter: rubigoRouter,
          ),
          initAndGetFirstScreen: () async => _Screens.s100,
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      await tester.runAsync(() async {
        unawaited(_testShowDialog(rubigoRouter));
      });
      expect(currentRouteIsPage(rubigoRouter), false);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(currentRouteIsPage(rubigoRouter), true);
      await tester.pumpAndSettle();
      expect(find.byType(_S200Screen), findsOne);
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'onDidRemovePage(splashScreen) called. Last page is s100, ignoring.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );
}

Future<void> _testShowDialog(RubigoRouter rubigoRouter) async {
  rubigoRouter.busyService.enabled = false;
  await showDialog<void>(
    context: rubigoRouter.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  rubigoRouter.busyService.enabled = true;
}

enum _Screens {
  splashScreen,
  s100,
  s200,
}

//region SplashScreen
class _SplashScreen extends StatelessWidget {
  //ignore: unused_element
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SplashController extends MockController<_Screens> {}
//endregion

//region S100Screen
class _S100Screen extends StatelessWidget
    with RubigoScreenMixin<_S100Controller> {
  //ignore: unused_element
  _S100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S100Controller extends MockController<_Screens> {}
//endregion

//region S200Screen
class _S200Screen extends StatelessWidget
    with RubigoScreenMixin<_S200Controller> {
  //ignore: unused_element
  _S200Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {}
//endregion
