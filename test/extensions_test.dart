import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'mock_controller/mock_controller.dart';

void main() {
  late RubigoHolder holder;
  setUp(
    () {
      holder = RubigoHolder();
    },
  );

  test(
    'find(screenId)',
    () {
      final availableScreens = [
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate<_S200Controller>(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate<_S300Controller>(_S300Controller.new),
        ),
      ];

      expect(availableScreens[0], availableScreens.find(_Screens.s100));
      expect(availableScreens[1], availableScreens.find(_Screens.s200));
      expect(availableScreens[2], availableScreens.find(_Screens.s300));
    },
  );

  test(
    'toListOfScreenId',
    () {
      final availableScreens = [
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate<_S200Controller>(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate<_S300Controller>(_S300Controller.new),
        ),
      ];
      final listOfScreenId = availableScreens.toListOfScreenId();
      expect(availableScreens[0].screenId, listOfScreenId[0]);
      expect(availableScreens[1].screenId, listOfScreenId[1]);
      expect(availableScreens[2].screenId, listOfScreenId[2]);
    },
  );

  test(
    'toListOfWidget',
    () {
      final availableScreens = [
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate<_S200Controller>(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate<_S300Controller>(_S300Controller.new),
        ),
      ];
      final listOfWidget = availableScreens.toListOfWidget();
      expect(availableScreens[0].screenWidget, listOfWidget[0]);
      expect(availableScreens[1].screenWidget, listOfWidget[1]);
      expect(availableScreens[2].screenWidget, listOfWidget[2]);
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
      final availableScreens = [
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate<_S200Controller>(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate<_S300Controller>(_S300Controller.new),
        ),
      ];
      final list1 = [
        availableScreens.find(_Screens.s100),
        availableScreens.find(_Screens.s200),
      ];
      final stack = [_Screens.s100, _Screens.s200];
      final list2 = stack.toListOfRubigoScreen(availableScreens);
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
        _Screens.s100,
        Container(),
        () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
      );
      final materialPage = s100.toMaterialPage();
      expect(materialPage.key, s100.pageKey);
      expect(materialPage.child, s100.screenWidget);
    },
  );

  test(
    'CupertinoPage',
    () {
      final s100 = RubigoScreen(
        _Screens.s100,
        Container(),
        () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
      );
      final cupertinoPage = s100.toCupertinoPage();
      expect(cupertinoPage.key, s100.pageKey);
      expect(cupertinoPage.child, s100.screenWidget);
    },
  );

  test(
    'currentScreenId',
    () async {
      final availableScreens = [
        RubigoScreen(
          _Screens.s100,
          _S100Screen(),
          () => holder.getOrCreate<_S100Controller>(_S100Controller.new),
        ),
        RubigoScreen(
          _Screens.s200,
          _S200Screen(),
          () => holder.getOrCreate<_S200Controller>(_S200Controller.new),
        ),
        RubigoScreen(
          _Screens.s300,
          _S300Screen(),
          () => holder.getOrCreate<_S300Controller>(_S300Controller.new),
        ),
      ];
      final rubigoRouter = RubigoRouter(
        getRubigoScreen: availableScreens,
        splashScreenId: _Screens.s100,
      );
      expect(rubigoRouter.currentScreenId, _Screens.s100);
      await rubigoRouter.init(initAndGetFirstScreen: () async => _Screens.s200);
      expect(rubigoRouter.currentScreenId, _Screens.s200);
      await rubigoRouter.push(_Screens.s300);
      expect(rubigoRouter.currentScreenId, _Screens.s300);
    },
  );
}

enum _Screens {
  s100,
  s200,
  s300,
}

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
