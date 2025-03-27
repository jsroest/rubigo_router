import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  late RubigoHolder holder;
  final logNavigation = <String>[];

  setUp(
    () {
      logNavigation.clear();
      holder = RubigoHolder();
      RubigoScreen<_Screens> screenProvider(_Screens screenId) {
        switch (screenId) {
          case _Screens.splashScreen:
            return RubigoScreen(
              screenId: _Screens.splashScreen,
              screenWidget: _SplashScreen.new,
              controller: () => holder.getOrCreate<_SplashController>(
                () => _SplashController(holder.get<RubigoRouter<_Screens>>()),
              ),
            );
          case _Screens.s100:
            return RubigoScreen(
              screenId: _Screens.s100,
              screenWidget: _S100Screen.new,
              controller: () => holder.getOrCreate<_S100Controller>(
                () => _S100Controller(holder.get<RubigoRouter<_Screens>>()),
              ),
            );
          case _Screens.s200:
            return RubigoScreen(
              screenId: _Screens.s200,
              screenWidget: _S200Screen.new,
              controller: () => holder.getOrCreate<_S200Controller>(
                () => _S200Controller(holder.get<RubigoRouter<_Screens>>()),
              ),
            );
        }
      }

      holder.getOrCreate(
        () => RubigoRouter(
          screenProvider: screenProvider,
          splashScreenId: _Screens.splashScreen,
          logNavigation: (message) async => logNavigation.add(message),
        ),
      );
    },
  );

  testWidgets('test a back gesture S100-S200 to S100', (tester) async {
    final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => _Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
    await tester.pumpAndSettle();
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
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
        'onDidRemovePage(s200) called.',
        'Call mayPop().',
        'The controller returned "true"',
        'pop() called.',
        'Screens: s100.',
      ],
    );
  });

  testWidgets('onDidRemovePage - updateScreensIsCalled is false',
      (tester) async {
    final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => _Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
    holder.get<_S200Controller>().allowPop = false;
    await tester.pumpAndSettle();
    // Start perform a back gesture
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    late final TransitionRoute<void> lastRoute;
    // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is/50817399#50817399
    navigator.popUntil(
      (route) {
        lastRoute = route as TransitionRoute<void>;
        return true;
      },
    );
    lastRoute.handleStartBackGesture(progress: 75);
    await tester.pumpAndSettle();
    lastRoute.handleCommitBackGesture();
    // End perform a back gesture
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
        'onDidRemovePage(s200) called.',
        'Call mayPop().',
        'The controller returned "false"',
        'Screens: s100→s200.',
      ],
    );
  });

  testWidgets('onDidRemovePage - execute workaround', (tester) async {
    final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
    await tester.pumpWidget(
      RubigoMaterialApp(
        backButtonDispatcher: RubigoRootBackButtonDispatcher(rubigoRouter),
        routerDelegate: RubigoRouterDelegate(
          rubigoRouter: rubigoRouter,
        ),
        initAndGetFirstScreen: () async => _Screens.s100,
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => rubigoRouter.ui.push(_Screens.s200));
    await tester.pumpAndSettle();
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
        'onDidRemovePage(s200) called.',
        '''
RubigoRouter warning.
"onDidRemovePage called" for s200, but the source was not a userGesture. 
The cause is most likely that Navigator.maybePop(context) was (indirectly) called.
This can happen when:
- A regular BackButton was used to pop this page. Solution: Use a rubigoBackButton in the AppBar.
- The MaterialApp.backButtonDispatcher was not a RubigoRootBackButtonDispatcher.
- The pop was not caught by a RubigoBackGesture widget.
''',
        'Call mayPop().',
        'The controller returned "true"',
        'pop() called.',
        'Screens: s100.',
      ],
    );
  });
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

class _SplashController extends MockController<_Screens> {
  _SplashController(super.rubigoRouter);
}
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

class _S100Controller extends MockController<_Screens> {
  _S100Controller(super.rubigoRouter);
}
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
          // This needs to be commented out to test the special situations
          // in this unit test.
          // leading: rubigoBackButton(context, controller.rubigoRouter),
          ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {
  _S200Controller(super.rubigoRouter);

  bool allowPop = true;

  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    return allowPop;
  }
}
//endregion
