import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:example/widgets/are_you_sure.dart';
import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S230Controller with RubigoControllerMixin<Screens> {
  S230Controller(this.rubigoRouter);

  final RubigoRouter<Screens> rubigoRouter;

  final allowBackGesture = ValueNotifier(false);

  final mayPop_ = ValueNotifier(true);

  final confirmPop = ValueNotifier(false);

  @override
  Future<bool> mayPop() async {
    if (mayPop_.value == false) {
      return false;
    }
    if (confirmPop.value == false) {
      return true;
    }
    return areYouSure(rubigoRouter);
  }

  Future<void> onPushS240ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s240);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS210ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s210);
  }

  Future<void> onRemoveS220ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s220);
  }

  Future<void> onRemoveS210ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s210);
  }

  Future<void> onResetStackButtonPressed() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s210,
        Screens.s220,
        Screens.s230,
      ],
    );
  }

  Future<void> onToSetAButtonPressed() async {
    screenStackBackupSet2 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet1);
  }

  Future<void> onToSetBButtonPressed() async {
    screenStackBackupSet2 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet3);
  }
}
