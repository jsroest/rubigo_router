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
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(() async {
    logNavigation.clear();
    holder = RubigoHolder();
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
        case _Screens.s300:
          return RubigoScreen(
            screenId: _Screens.s300,
            getScreenWidget: _S300Screen.new,
            getController: () =>
                holder.getOrCreate<_S300Controller>(_S300Controller.new),
            getRubigoRouter: () => rubigoRouter,
          );
      }
    }

    rubigoRouter = RubigoRouter(
      getRubigoScreen: getRubigoScreen,
      splashScreenId: _Screens.splashScreen,
      logNavigation: (message) async => logNavigation.add(message),
    );
    await rubigoRouter.init(initAndGetFirstScreen: () async => _Screens.s100);
  });

  test(
    'S100 push(S200), when busy',
    () async {
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.push(_Screens.s200);
        },
      );

      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  test(
    'S100 push(S200), when not busy',
    () async {
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      await rubigoRouter.push(_Screens.s200);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.push,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'push(s200) called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  test(
    'S100 replaceStack(S100-S200-S300), busy',
    () async {
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.replaceStack([
            _Screens.s100,
            _Screens.s200,
            _Screens.s300,
          ]);
        },
      );
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
          _Screens.s300,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
        ],
      );
    },
  );

  test(
    'S100 replaceStack(S100-S200-S300), when not busy',
    () async {
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
          _Screens.s300,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s300Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.replaceStack,
              _Screens.s100,
              [
                _Screens.s100,
                _Screens.s200,
                _Screens.s300,
              ],
            ),
          ),
        ],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 pop(), when busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.pop();
        },
      );

      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'pop() called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 pop(), when not busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.pop();
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s200,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.pop,
              _Screens.s300,
              [
                _Screens.s100,
                _Screens.s200,
              ],
            ),
          ),
        ],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'pop() called.',
          'Screens: s100→s200.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 popTo(S100) when busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.popTo(_Screens.s100);
        },
      );
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
        ],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'popTo(s100) called.',
          'Screens: s100.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 popTo(S100) when not busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.popTo(_Screens.s100);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        [
          OnTopCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
          WillShowCallBack(
            const RubigoChangeInfo(
              EventType.popTo,
              _Screens.s300,
              [
                _Screens.s100,
              ],
            ),
          ),
        ],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'popTo(s100) called.',
          'Screens: s100.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 remove(S200) when busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.busyService.busyWrapper(
        () async {
          await rubigoRouter.remove(_Screens.s200);
        },
      );
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s300,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'remove(s200) called.',
          'Screens: s100→s300.',
        ],
      );
    },
  );

  test(
    'S100-s200-s300 remove(S200) when not busy',
    () async {
      await rubigoRouter.replaceStack([
        _Screens.s100,
        _Screens.s200,
        _Screens.s300,
      ]);
      final s100Controller =
          holder.getOrCreate<_S100Controller>(_S100Controller.new);
      s100Controller.callBackHistory.clear();
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.callBackHistory.clear();
      final s300Controller =
          holder.getOrCreate<_S300Controller>(_S300Controller.new);
      s300Controller.callBackHistory.clear();
      await rubigoRouter.remove(_Screens.s200);
      expect(
        rubigoRouter.screens.toListOfScreenId(),
        [
          _Screens.s100,
          _Screens.s300,
        ],
      );
      expect(
        s100Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        s200Controller.callBackHistory,
        <CallBack>[RemovedFromStackCallBack()],
      );
      expect(
        s300Controller.callBackHistory,
        <CallBack>[],
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'replaceStack(s100→s200→s300) called.',
          'Screens: s100→s200→s300.',
          'remove(s200) called.',
          'Screens: s100→s300.',
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

class _S300Controller extends MockController<_Screens> {}
//endregion
