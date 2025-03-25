import 'package:flutter_test/flutter_test.dart';
import 'package:rubigo_router/rubigo_router.dart';

enum _Screens {
  s100,
  s200,
  s300,
}

void main() {
  final screenStacks = [
    <_Screens>[],
    [_Screens.s100],
    [_Screens.s100, _Screens.s200],
    [_Screens.s100, _Screens.s300],
  ];
  test(
    'test rubigo_change_info ',
    () {
      final hashCodes = <int>[];
      for (final eventType in EventType.values) {
        for (final screenId in _Screens.values) {
          for (final screenStack in screenStacks) {
            final changeInfo1 = RubigoChangeInfo<_Screens>(
              eventType,
              screenId,
              screenStack,
            );
            final changeInfo2 = RubigoChangeInfo<_Screens>(
              eventType,
              screenId,
              screenStack,
            );
            expect(changeInfo1, changeInfo2);
            final hashCode1 = changeInfo1.hashCode;
            final hashCode2 = changeInfo2.hashCode;
            expect(hashCode1, hashCode2);
            expect(hashCodes.contains(hashCode1), false);
            hashCodes.add(hashCode1);
          }
        }
      }
    },
  );
}
