import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/callbacks.dart';
import 'mock_controller/mock_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<_Screens>> availableScreens;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(() async {});

  test(
    'AuthChange event before init is finished',
    () async {
      logNavigation.clear();
      holder = RubigoHolder();
      availableScreens = [
        RubigoScreen(
          _Screens.splashScreen,
          const _SplashScreen(),
          () => holder.getOrCreate<_SplashController>(_SplashController.new),
        ),
        RubigoScreen(
          _Screens.s100LoginScreen,
          _S100LoginScreen(),
          () => holder
              .getOrCreate<_S100LoginController>(_S100LoginController.new),
        ),
        RubigoScreen(
          _Screens.s200HomeScreen,
          _S200HomeScreen(),
          () =>
              holder.getOrCreate<_S200HomeController>(_S200HomeController.new),
        ),
      ];
      rubigoRouter = RubigoRouter(
        getRubigoScreen: availableScreens,
        splashScreenId: _Screens.splashScreen,
        logNavigation: (message) async => logNavigation.add(message),
      );
      await _handleAuthChangeEvent(
        isInitialized: rubigoRouter.isInitialized,
        isAuthenticated: true,
        rubigoRouter: rubigoRouter,
      );
      expect(rubigoRouter.isInitialized, false);
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => _Screens.s100LoginScreen,
      );
      expect(rubigoRouter.isInitialized, true);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s200HomeScreen,
        ],
      );
      final s100LoginController = holder.get<_S100LoginController>();
      expect(
        s100LoginController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.splashScreen,
              [
                _Screens.s100LoginScreen,
              ],
            ),
          ),
          RemovedFromStackCallBack(),
        ],
      );
      final s200HomeController = holder.get<_S200HomeController>();
      expect(
        s200HomeController.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100LoginScreen,
              [
                _Screens.s200HomeScreen,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100LoginScreen,
              [
                _Screens.s200HomeScreen,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100LoginScreen.',
          'replaceStack(s100LoginScreen) called.',
          'Screens: s100LoginScreen.',
          'replaceStack(s200HomeScreen) called.',
          'Screens: s200HomeScreen.',
        ],
      );
    },
  );
}

enum _Screens {
  splashScreen,
  s100LoginScreen,
  s200HomeScreen,
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

class _S100LoginController extends MockController<_Screens> {}
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

class _S200HomeController extends MockController<_Screens> {}
//endregion

//region handleAuthChangeEvent
Future<void> _handleAuthChangeEvent({
  required bool isInitialized,
  required bool isAuthenticated,
  required RubigoRouter<_Screens> rubigoRouter,
}) async {
  if (rubigoRouter.isNavigating || !isInitialized) {
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
