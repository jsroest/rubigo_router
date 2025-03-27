import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

enum _Screens {
  s100,
  s200,
}

void main() {
  test(
    'Test rubigo screen equality and hashcode',
    () {
      final screen1 = RubigoScreen(
        screenId: _Screens.s100,
        screenWidget: Container.new,
        controller: Object.new,
      );
      final screen2 = RubigoScreen(
        screenId: _Screens.s100,
        screenWidget: Container.new,
        controller: Object.new,
      );
      final screen3 = RubigoScreen(
        screenId: _Screens.s200,
        screenWidget: Container.new,
        controller: Object.new,
      );
      expect(screen1, screen2);
      expect(screen1.hashCode, screen2.hashCode);
      expect(screen2, isNot(screen3));
      expect(screen2, isNot(screen3.hashCode));
    },
  );
}
