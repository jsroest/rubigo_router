import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

enum _Screens {
  s100,
  s200,
}

void main() {
  final rubigoRouter = RubigoRouter(
    splashScreenId: 'a',
    screenProvider: (String screenId) => throw UnimplementedError(),
  );

  test(
    'Test rubigo screen equality and hashcode',
    () {
      final screen1 = RubigoScreen(
        screenId: _Screens.s100,
        getScreenWidget: Container.new,
        getController: Object.new,
        getRubigoRouter: () => rubigoRouter,
      );
      final screen2 = RubigoScreen(
        screenId: _Screens.s100,
        getScreenWidget: Container.new,
        getController: Object.new,
        getRubigoRouter: () => rubigoRouter,
      );
      final screen3 = RubigoScreen(
        screenId: _Screens.s200,
        getScreenWidget: Container.new,
        getController: Object.new,
        getRubigoRouter: () => rubigoRouter,
      );
      expect(screen1, screen2);
      expect(screen1.hashCode, screen2.hashCode);
      expect(screen2, isNot(screen3));
      expect(screen2, isNot(screen3.hashCode));
    },
  );
}
