import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  late RubigoRouter<_Screens> rubigoRouter;
  final holder = RubigoHolder();
  final key = GlobalKey<NavigatorState>();

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
    }
  }

  test(
    'Navigator key passed',
    () {
      rubigoRouter = RubigoRouter<_Screens>(
        screenProvider: screenProvider,
        navigatorKey: key,
        splashScreenId: _Screens.splashScreen,
      );
      expect(
        identical(rubigoRouter.navigatorKey, key),
        true,
      );
    },
  );

  test(
    'Navigator key not passed',
    () {
      rubigoRouter = RubigoRouter<_Screens>(
        screenProvider: screenProvider,
        splashScreenId: _Screens.splashScreen,
      );
      expect(
        identical(rubigoRouter.navigatorKey, key),
        false,
      );
    },
  );
}

enum _Screens {
  splashScreen,
  s100,
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
