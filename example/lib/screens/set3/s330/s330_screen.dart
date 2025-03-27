import 'package:example/screens/screens.dart';
import 'package:example/screens/set3/s330/s330_controller.dart';
import 'package:example/screens/widgets/sx30_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S330Screen extends StatelessWidget
    with RubigoScreenMixin<S330Controller> {
  S330Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx30Screen(
      rubigoRouter: controller.rubigoRouter,
      sX10Screen: Screens.s310,
      sX20Screen: Screens.s320,
      sX30Screen: Screens.s330,
      sX40Screen: Screens.s340,
      allowBackGesture: controller.allowBackGesture,
      mayPop: controller.mayPop_,
      confirmPop: controller.confirmPop,
      onPushSx040ButtonPressed: controller.onPushS340ButtonPressed,
      onPopButtonPressed: controller.onPopButtonPressed,
      onPopToSx10ButtonPressed: controller.onPopToS310ButtonPressed,
      onRemoveSx10ButtonPressed: controller.onRemoveS310ButtonPressed,
      onRemoveSx20ButtonPressed: controller.onRemoveS320ButtonPressed,
      onResetStackButtonPressed: controller.onResetStackButtonPressed,
      onToSetAButtonPressed: controller.onToSetAButtonPressed,
      toSetAButtonText: 'Replace set 1',
      onToSetBButtonPressed: controller.onToSetBButtonPressed,
      toSetBButtonText: 'Replace set 2',
    );
  }
}
