import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/callbacks.dart';
import 'mock_controller/mock_controller.dart';

enum _Screens {
  splashScreen,
  s100,
  s200,
  s300,
}

void main() {
  late RubigoHolder holder;

  setUp(() {
    holder = RubigoHolder();
    RubigoScreen<_Screens> screenProvider(
      _Screens screenId,
    ) {
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
        case _Screens.s300:
          return RubigoScreen(
            screenId: _Screens.s300,
            screenWidget: _S300Screen.new,
            controller: () => holder.getOrCreate<_S300Controller>(
              () => _S300Controller(holder.get<RubigoRouter<_Screens>>()),
            ),
          );
      }
    }

    holder.getOrCreate(
      () => RubigoRouter(
        screenProvider: screenProvider,
        splashScreenId: _Screens.splashScreen,
      ),
    );
  });

  test(
    'SplashScreen to S100',
    () async {
      final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => _Screens.s100,
      );
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [_Screens.s100],
      );
      final splashController = holder.get<_SplashController>();
      expect(
        splashController.callBackHistory,
        [RemovedFromStackCallBack()],
      );
      final s100Controller = holder.get<_S100Controller>();
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [_Screens.s100],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [_Screens.s100],
            ),
          ),
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
        leading: rubigoBackButton(context, controller.rubigoRouter),
      ),
      body: const Placeholder(),
    );
  }
}

class _S200Controller extends MockController<_Screens> {
  _S200Controller(super.rubigoRouter);
}
//endregion

//region S300Screen
class _S300Screen extends StatelessWidget
    with RubigoScreenMixin<_S300Controller> {
//ignore: unused_element
  _S300Screen({super.key});

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

class _S300Controller extends MockController<_Screens> {
  _S300Controller(super.rubigoRouter);
}
//endregion
