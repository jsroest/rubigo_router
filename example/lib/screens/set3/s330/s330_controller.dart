import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/screen_stack_backup_set1.dart';
import 'package:example/screens/set2/screen_stack_backup_set2.dart';
import 'package:example/screens/set3/screen_stack_backup_set3.dart';
import 'package:example/widgets/are_you_sure.dart';
import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S330Controller with RubigoControllerMixin<Screens> {
  S330Controller(this.rubigoRouter);

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

  Future<void> onPushS340ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s340);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }

  Future<void> onPopToS310ButtonPressed() async {
    await rubigoRouter.ui.popTo(Screens.s310);
  }

  Future<void> onRemoveS320ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s320);
  }

  Future<void> onRemoveS310ButtonPressed() async {
    await rubigoRouter.ui.remove(Screens.s310);
  }

  Future<void> onResetStackButtonPressed() async {
    await rubigoRouter.ui.replaceStack(
      [
        Screens.s310,
        Screens.s320,
        Screens.s330,
      ],
    );
  }

  Future<void> onToSetAButtonPressed() async {
    screenStackBackupSet3 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet1);
  }

  Future<void> onToSetBButtonPressed() async {
    screenStackBackupSet3 = rubigoRouter.screens.toListOfScreenId();
    await rubigoRouter.ui.replaceStack(screenStackBackupSet2);
  }
}
