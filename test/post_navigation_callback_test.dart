import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/callbacks.dart';
import 'mock_controller/mock_controller.dart';

enum _Screens {
  splashScreen,
  s100LoginScreen,
  s200HomeScreen,
  s300GiveLocation,
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  final logNavigation = <String>[];

  setUp(() async {
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
        case _Screens.s100LoginScreen:
          return RubigoScreen(
            screenId: _Screens.s100LoginScreen,
            screenWidget: _S100LoginScreen.new,
            controller: () => holder.getOrCreate<_S100LoginController>(
              () => _S100LoginController(holder.get<RubigoRouter<_Screens>>()),
            ),
          );
        case _Screens.s200HomeScreen:
          return RubigoScreen(
            screenId: _Screens.s200HomeScreen,
            screenWidget: _S200HomeScreen.new,
            controller: () => holder.getOrCreate<_S200HomeController>(
              () => _S200HomeController(holder.get<RubigoRouter<_Screens>>()),
            ),
          );
        case _Screens.s300GiveLocation:
          return RubigoScreen(
            screenId: _Screens.s300GiveLocation,
            screenWidget: _S300GiveLocationScreen.new,
            controller: () => holder.getOrCreate<_S300GiveLocationController>(
              () => _S300GiveLocationController(
                holder.get<RubigoRouter<_Screens>>(),
              ),
            ),
          );
      }
    }

    final rubigoRouter = RubigoRouter(
      screenProvider: screenProvider,
      splashScreenId: _Screens.splashScreen,
      logNavigation: (message) async => logNavigation.add(message),
    );
    holder.getOrCreate(() => rubigoRouter);
    await rubigoRouter.init(
      initAndGetFirstScreen: () async => _Screens.s200HomeScreen,
    );
    //Make sure all items are available in the holder
    holder.getOrCreate<_SplashController>(
      () => _SplashController(holder.get<RubigoRouter<_Screens>>()),
    );
    holder.getOrCreate<_S100LoginController>(
      () => _S100LoginController(holder.get<RubigoRouter<_Screens>>()),
    );
    holder.getOrCreate<_S200HomeController>(
      () => _S200HomeController(holder.get<RubigoRouter<_Screens>>()),
    );
    holder.getOrCreate<_S300GiveLocationController>(
      () => _S300GiveLocationController(holder.get<RubigoRouter<_Screens>>()),
    );
  });

  test(
    'S200 push(S300), simulate auth change in onTop s300',
    () async {
      final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
      final s100LoginController = holder.get<_S100LoginController>();
      s100LoginController.callBackHistory.clear();
      final s200HomeController = holder.get<_S200HomeController>();
      s200HomeController.callBackHistory.clear();
      final s300GiveLocationController =
          holder.get<_S300GiveLocationController>();
      s300GiveLocationController.callBackHistory.clear();
      s300GiveLocationController.authChangeInOnTop = true;
      await rubigoRouter.push(_Screens.s300GiveLocation);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100LoginScreen,
        ],
      );
      expect(
        s100LoginController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s300GiveLocation,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s300GiveLocation,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
        ],
      );
      expect(
        s200HomeController.callBackHistory,
        [
          RemovedFromStackCallBack(),
        ],
      );
      expect(
        s300GiveLocationController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
          RemovedFromStackCallBack(),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s200HomeScreen.',
          'replaceStack(s200HomeScreen) called.',
          'Screens: s200HomeScreen.',
          'push(s300GiveLocation) called.',
          'Screens: s200HomeScreen→s300GiveLocation.',
          'replaceStack(s100LoginScreen) called.',
          'Screens: s100LoginScreen.',
        ],
      );
    },
  );

  test(
    'S200 push(S300), simulate auth change in willShow s300',
    () async {
      final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
      final s100LoginController = holder.get<_S100LoginController>();
      s100LoginController.callBackHistory.clear();
      final s200HomeController = holder.get<_S200HomeController>();
      s200HomeController.callBackHistory.clear();
      final s300GiveLocationController =
          holder.get<_S300GiveLocationController>();
      s300GiveLocationController.callBackHistory.clear();
      s300GiveLocationController.authChangeInWillShow = true;
      await rubigoRouter.push(_Screens.s300GiveLocation);

      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100LoginScreen,
        ],
      );
      expect(
        s100LoginController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s300GiveLocation,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s300GiveLocation,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
        ],
      );
      expect(
        s200HomeController.callBackHistory,
        [
          RemovedFromStackCallBack(),
        ],
      );
      expect(
        s300GiveLocationController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
          RemovedFromStackCallBack(),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s200HomeScreen.',
          'replaceStack(s200HomeScreen) called.',
          'Screens: s200HomeScreen.',
          'push(s300GiveLocation) called.',
          'Screens: s200HomeScreen→s300GiveLocation.',
          'replaceStack(s100LoginScreen) called.',
          'Screens: s100LoginScreen.',
        ],
      );
    },
  );

  test(
    'S200 push(S300), simulate auth change in onTop, cancel in willShow s300',
    () async {
      final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
      final s100LoginController = holder.get<_S100LoginController>();
      s100LoginController.callBackHistory.clear();
      final s200HomeController = holder.get<_S200HomeController>();
      s200HomeController.callBackHistory.clear();
      final s300GiveLocationController =
          holder.get<_S300GiveLocationController>();
      s300GiveLocationController.callBackHistory.clear();
      s300GiveLocationController.authChangeInOnTop = true;
      s300GiveLocationController.cancelAuthChangeInWillShow = true;
      await rubigoRouter.push(_Screens.s300GiveLocation);

      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s200HomeScreen,
          _Screens.s300GiveLocation,
        ],
      );
      expect(
        s100LoginController.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200HomeController.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300GiveLocationController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s200HomeScreen,
              [
                _Screens.s200HomeScreen,
                _Screens.s300GiveLocation,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s200HomeScreen.',
          'replaceStack(s200HomeScreen) called.',
          'Screens: s200HomeScreen.',
          'push(s300GiveLocation) called.',
          'Screens: s200HomeScreen→s300GiveLocation.',
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
class _S100LoginScreen extends StatelessWidget
    with RubigoScreenMixin<_S100LoginController> {
  //ignore: unused_element
  _S100LoginScreen({super.key});

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

class _S100LoginController extends MockController<_Screens> {
  _S100LoginController(super.rubigoRouter);
}
//endregion

//region S200Screen
class _S200HomeScreen extends StatelessWidget
    with RubigoScreenMixin<_S200HomeController> {
  //ignore: unused_element
  _S200HomeScreen({super.key});

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

class _S200HomeController extends MockController<_Screens> {
  _S200HomeController(super.rubigoRouter);
}
//endregion

//region S300Screen
class _S300GiveLocationScreen extends StatelessWidget
    with RubigoScreenMixin<_S300GiveLocationController> {
  //ignore: unused_element
  _S300GiveLocationScreen({super.key});

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

class _S300GiveLocationController extends MockController<_Screens> {
  _S300GiveLocationController(super.rubigoRouter);

  bool authChangeInOnTop = false;
  bool authChangeInWillShow = false;
  bool cancelAuthChangeInWillShow = false;

  @override
  Future<void> onTop(RubigoChangeInfo<_Screens> changeInfo) async {
    await super.onTop(changeInfo);
    //Simulate auth change in onTop
    if (authChangeInOnTop) {
      await _handleAuthChangeEvent(
        isAuthenticated: false,
        rubigoRouter: rubigoRouter,
      );
    }
  }

  @override
  Future<void> willShow(RubigoChangeInfo<_Screens> changeInfo) async {
    await super.willShow(changeInfo);
    if (authChangeInWillShow) {
      await _handleAuthChangeEvent(
        isAuthenticated: false,
        rubigoRouter: rubigoRouter,
      );
    }
    if (cancelAuthChangeInWillShow) {
      rubigoRouter.registerPostNavigationCallback(null);
    }
  }
}
//endregion

//region handleAuthChangeEvent
Future<void> _handleAuthChangeEvent({
  required bool isAuthenticated,
  required RubigoRouter<_Screens> rubigoRouter,
}) async {
  if (rubigoRouter.isNavigating) {
    rubigoRouter.registerPostNavigationCallback(() async {
      await _performAuthChangeNavigation(
        isAuthenticated: isAuthenticated,
        rubigoRouter: rubigoRouter,
      );
    });
    return;
  }
  await _performAuthChangeNavigation(
    isAuthenticated: isAuthenticated,
    rubigoRouter: rubigoRouter,
  );
}

Future<void> _performAuthChangeNavigation({
  required bool isAuthenticated,
  required RubigoRouter<_Screens> rubigoRouter,
}) async {
  switch (isAuthenticated) {
    case true:
      if (rubigoRouter.currentScreenId == _Screens.s100LoginScreen) {
        await rubigoRouter.replaceStack([_Screens.s200HomeScreen]);
      }
    case false:
      if (rubigoRouter.currentScreenId != _Screens.s100LoginScreen) {
        await rubigoRouter.replaceStack([_Screens.s100LoginScreen]);
      }
  }
}

//endregion
