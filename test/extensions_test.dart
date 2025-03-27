import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

enum _Screens {
  splashScreen,
  s100,
  s200,
  s300,
}

void main() {
  late RubigoHolder holder;
  late RubigoScreen<_Screens> Function(_Screens screenId) screenProvider;

  setUp(
    () {
      holder = RubigoHolder();
      screenProvider = (_Screens screenId) {
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
      };
      holder.getOrCreate<RubigoRouter<_Screens>>(
        () => RubigoRouter(
          screenProvider: screenProvider,
          splashScreenId: _Screens.splashScreen,
        ),
      );
    },
  );

  test(
    'toListOfScreenId',
    () {
      final availableScreens =
          _Screens.values.map((e) => screenProvider(e)).toList();
      final listOfScreenId = availableScreens.toListOfScreenId();
      expect(availableScreens[0].screenId, listOfScreenId[0]);
      expect(availableScreens[1].screenId, listOfScreenId[1]);
      expect(availableScreens[2].screenId, listOfScreenId[2]);
    },
  );

  test(
    'toListOfWidget',
    () {
      final availableScreens =
          _Screens.values.map((e) => screenProvider(e)).toList();
      final listOfWidget = availableScreens.toListOfWidget();
      expect(
        availableScreens[0].screenWidget().runtimeType,
        listOfWidget[0].runtimeType,
      );
      expect(
        availableScreens[1].screenWidget().runtimeType,
        listOfWidget[1].runtimeType,
      );
      expect(
        availableScreens[2].screenWidget().runtimeType,
        listOfWidget[2].runtimeType,
      );
    },
  );

  test(
    'hasScreenBelow',
    () {
      const topPage = _Screens.s100;
      final stack = [
        _Screens.s200,
        topPage,
      ];
      expect(stack.hasScreenBelow(), true);
      stack.remove(_Screens.s200);
      expect(stack.hasScreenBelow(), false);
    },
  );

  test(
    'containsScreenBelow',
    () {
      const topPage = _Screens.s100;
      final stack = [
        _Screens.s200,
        topPage,
      ];
      expect(stack.containsScreenBelow(_Screens.s300), false);
      expect(stack.containsScreenBelow(_Screens.s200), true);
      expect(stack.containsScreenBelow(_Screens.s100), false);
    },
  );

  test(
    'toListOfRubigoScreen',
    () {
      final availableScreens =
          _Screens.values.map((e) => screenProvider(e)).toList();
      final list1 = [
        availableScreens.find(_Screens.s100),
        availableScreens.find(_Screens.s200),
      ];
      final stack = [_Screens.s100, _Screens.s200];
      final list2 = stack.toListOfRubigoScreen(screenProvider);
      expect(listEquals(list1, list2), true);
    },
  );

  test(
    'Breadcrumbs',
    () {
      final stack = [_Screens.s100, _Screens.s200];
      final breadCrumbs = stack.breadCrumbs();
      expect(breadCrumbs, 'S100→S200');
    },
  );

  test(
    'MaterialPage',
    () {
      final s100 = RubigoScreen(
        screenId: _Screens.s100,
        screenWidget: Container.new,
        controller: () => holder.getOrCreate<_S100Controller>(
          () => _S100Controller(holder.get<RubigoRouter<_Screens>>()),
        ),
      );
      final materialPage = s100.toMaterialPage();
      expect(materialPage.key, s100.pageKey);
      expect(materialPage.child.runtimeType, s100.screenWidget().runtimeType);
    },
  );

  test(
    'CupertinoPage',
    () {
      final s100 = RubigoScreen(
        screenId: _Screens.s100,
        screenWidget: Container.new,
        controller: () => holder.getOrCreate<_S100Controller>(
          () => _S100Controller(holder.get<RubigoRouter<_Screens>>()),
        ),
      );
      final cupertinoPage = s100.toCupertinoPage();
      expect(cupertinoPage.key, s100.pageKey);
      expect(cupertinoPage.child.runtimeType, s100.screenWidget().runtimeType);
    },
  );

  test(
    'currentScreenId',
    () async {
      final rubigoRouter = holder.get<RubigoRouter<_Screens>>();
      expect(rubigoRouter.currentScreenId, _Screens.splashScreen);
      await rubigoRouter.init(initAndGetFirstScreen: () async => _Screens.s100);
      expect(rubigoRouter.currentScreenId, _Screens.s100);
      await rubigoRouter.push(_Screens.s200);
      expect(rubigoRouter.currentScreenId, _Screens.s200);
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
