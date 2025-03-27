import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s130/s130_controller.dart';
import 'package:example/screens/widgets/sx30_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S130Screen extends StatelessWidget
    with RubigoScreenMixin<S130Controller> {
  S130Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx30Screen(
      rubigoRouter: controller.rubigoRouter,
      sX10Screen: Screens.s110,
      sX20Screen: Screens.s120,
      sX30Screen: Screens.s130,
      sX40Screen: Screens.s140,
      allowBackGesture: controller.allowBackGesture,
      mayPop: controller.mayPop_,
      confirmPop: controller.confirmPop,
      onPushSx040ButtonPressed: controller.onPushS140ButtonPressed,
      onPopButtonPressed: controller.onPopButtonPressed,
      onPopToSx10ButtonPressed: controller.onPopToS110ButtonPressed,
      onRemoveSx10ButtonPressed: controller.onRemoveS110ButtonPressed,
      onRemoveSx20ButtonPressed: controller.onRemoveS120ButtonPressed,
      onResetStackButtonPressed: controller.onResetStackButtonPressed,
      onToSetAButtonPressed: controller.onToSetAButtonPressed,
      toSetAButtonText: 'Replace set 2',
      onToSetBButtonPressed: controller.onToSetBButtonPressed,
      toSetBButtonText: 'Replace set 3',
    );
  }
}
