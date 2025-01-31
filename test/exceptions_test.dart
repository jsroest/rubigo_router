import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RubigoHolder holder;
  late List<RubigoScreen<_Screens>> availableScreens;
  late RubigoRouter<_Screens> rubigoRouter;

  setUp(
    () async {
      holder = RubigoHolder();
      availableScreens = [
        RubigoScreen(
          _Screens.splashScreen,
          const _SplashScreen(),
          () => holder.getOrCreate(_SplashController.new),
        ),
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate(_S300Controller.new),
        ),
      ];
      rubigoRouter = RubigoRouter(
        availableScreens: availableScreens,
        splashScreenId: _Screens.splashScreen,
      );
      await rubigoRouter.init(
        initAndGetFirstScreen: () async => _Screens.s100,
      );
    },
  );

  test(
    'Navigate in willShow',
    () async {
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.willShowPush = _Screens.s300;
      await expectLater(
        () async => rubigoRouter.prog.push(_Screens.s200),
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
    },
  );

  test(
    'Navigate in removedFromStack',
    () async {
      final s200Controller = holder.get<_S200Controller>();
      s200Controller.removedFromStackPush = _Screens.s300;
      await rubigoRouter.prog.push(_Screens.s200);
      await expectLater(
        () async => rubigoRouter.prog.pop(),
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
    },
  );

  test(
    'PopTo a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.popTo(_Screens.s200),
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
    },
  );

  test(
    'PopTo the current screen',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.popTo(_Screens.s100),
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
    },
  );

  test(
    'Remove a screen that is not on the stack',
    () async {
      await expectLater(
        () async => rubigoRouter.prog.remove(_Screens.s200),
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
                    'PANIC: page.key must be of type ValueKey<_Screens>.',
          ),
        ),
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
                    'PANIC: page.key must be of type ValueKey<_Screens>.',
          ),
        ),
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
      await rubigoRouter.prog.pop();
      expect(message, 'SystemNavigator.pop');
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
    with RubigoScreenMixin<_S200Controller> {
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
