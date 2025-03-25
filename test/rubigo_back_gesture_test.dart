import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

enum _Screens {
  splashScreen,
  s100,
  s200,
}

void main() {
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];
  setUp(
    () {
      logNavigation.clear();
      final holder = RubigoHolder();

      RubigoScreen<_Screens> getRubigoScreen(_Screens screenId) {
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
        getRubigoScreen: getRubigoScreen,
        splashScreenId: _Screens.splashScreen,
        logNavigation: (message) async => logNavigation.add(message),
      );
    },
  );
  testWidgets(
    'rubigoBackGesture',
    (tester) async {
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
          'Call mayPop().',
          'The controller returned "true"',
          'pop() called.',
          'Screens: s100.',
          'onDidRemovePage(s200) called. Last page is s100, ignoring.',
        ],
      );
    },
  );
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
    return RubigoBackGesture(
      allowBackGesture: false,
      rubigoRouter: controller.rubigoRouter,
      child: Scaffold(
        appBar: AppBar(
            // This needs to be commented out to test the RubigoBackGesture
            // widget
            //leading: rubigoBackButton(context, controller.rubigoRouter),
            ),
        body: const Placeholder(),
      ),
    );
  }
}

class _S200Controller extends MockController<_Screens> {}
//endregion
