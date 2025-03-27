import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:example/widgets/are_you_sure.dart';
import 'package:flutter/cupertino.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S130Controller with RubigoControllerMixin<Screens> {
  S130Controller(this.rubigoRouter);

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

  Future<void> onPushS140ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s140);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS110ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s110);
  }

  Future<void> onRemoveS120ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s120);
  }

  Future<void> onRemoveS110ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s110);
  }

  Future<void> onResetStackButtonPressed() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s110,
        Screens.s120,
        Screens.s130,
      ],
    );
  }

  Future<void> onToSetAButtonPressed() async {
    screenStackBackupSet1 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet2);
  }

  Future<void> onToSetBButtonPressed() async {
    screenStackBackupSet1 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet3);
  }
}
