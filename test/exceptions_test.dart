import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late RubigoRouter<_Screens> rubigoRouter;
  final logNavigation = <String>[];

  setUp(
    () async {
      logNavigation.clear();
      holder = RubigoHolder();
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
        screenProvider: screenProvider,
        splashScreenId: _Screens.splashScreen,
        logNavigation: (message) async => logNavigation.add(message),
      );
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => _Screens.s100,
      );
    },
  );

  test(
    'Navigate in willShow',
    () async {
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.willShowPush = _Screens.s300;
      await expectLater(
        () async => rubigoRouter.push(_Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: you may not call push, pop, popTo, '
                        'replaceStack or remove in the willShow method.',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'push(s200) called.',
          'push(s300) called.',
          //ignore: lines_longer_than_80_chars
          'Developer: you may not call push, pop, popTo, replaceStack or remove in the willShow method.',
        ],
      );
    },
  );

  test(
    'Navigate in removedFromStack',
    () async {
      final s200Controller =
          holder.getOrCreate<_S200Controller>(_S200Controller.new);
      s200Controller.removedFromStackPush = _Screens.s300;
      await rubigoRouter.push(_Screens.s200);
      await expectLater(
        () async => rubigoRouter.pop(),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: you may not call push, pop, popTo, '
                        'replaceStack or remove in the removedFromStack '
                        'method.',
          ),
        ),
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
          'pop() called.',
          'Screens: s100.',
          'push(s300) called.',
          //ignore: lines_longer_than_80_chars
          'Developer: you may not call push, pop, popTo, replaceStack or remove in the removedFromStack method.',
        ],
      );
    },
  );

  test(
    'PopTo a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.popTo(_Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to s200, '
                        'which was not below this screen on the stack.',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'popTo(s200) called.',
          //ignore: lines_longer_than_80_chars
          'Developer: With popTo, you tried to navigate to s200, which was not below this screen on the stack.',
        ],
      );
    },
  );

  test(
    'PopTo the current screen',
    () async {
      await expectLater(
        () async => rubigoRouter.popTo(_Screens.s100),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: With popTo, you tried to navigate to s100, '
                        'which was not below this screen on the stack.',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'popTo(s100) called.',
          //ignore: lines_longer_than_80_chars
          'Developer: With popTo, you tried to navigate to s100, which was not below this screen on the stack.',
        ],
      );
    },
  );

  test(
    'Remove a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.remove(_Screens.s200),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'Developer: You can only remove screens that exist on the '
                        'stack (s200 not found).',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'remove(s200) called.',
          //ignore: lines_longer_than_80_chars
          'Developer: You can only remove screens that exist on the stack (s200 not found).',
        ],
      );
    },
  );

  test(
    'Remove a Page object with key is null',
    () async {
      const page = MaterialPage<void>(child: Placeholder());
      await expectLater(
        () async => rubigoRouter.onDidRemovePage(page),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'PANIC: page.key must be of type ValueKey<_Screens>, but '
                        'found null.',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'PANIC: page.key must be of type ValueKey<_Screens>, but found null.',
        ],
      );
    },
  );

  test(
    'Remove a Page object with an invalid ValueKey',
    () async {
      const page = MaterialPage<void>(key: ValueKey(1), child: Placeholder());
      await expectLater(
        () async => rubigoRouter.onDidRemovePage(page),
        throwsA(
          predicate(
            (e) =>
                e is UnsupportedError &&
                e.message ==
                    'PANIC: page.key must be of type ValueKey<_Screens>, but '
                        'found ValueKey<int>.',
          ),
        ),
      );
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          //ignore: lines_longer_than_80_chars
          'PANIC: page.key must be of type ValueKey<_Screens>, but found ValueKey<int>.',
        ],
      );
    },
  );

  testWidgets(
    'Remove last screen on the stack',
    (tester) async {
      var message = '';
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (value) async {
          message = value.method;
          return null;
        },
      );
      await rubigoRouter.pop();
      expect(message, 'SystemNavigator.pop');
      expect(
        logNavigation,
        [
          'RubigoRouter.init() called.',
          'RubigoRouter.init() ended. First screen will be s100.',
          'replaceStack(s100) called.',
          'Screens: s100.',
          'pop() called.',
          'The last page is popped.',
        ],
      );
    },
  );
}

enum _Screens {
  splashScreen,
  s100,
  s200,
  s300,
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
