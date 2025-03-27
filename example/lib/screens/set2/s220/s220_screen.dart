import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s220/s220_controller.dart';
import 'package:example/screens/widgets/sx20_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S220Screen extends StatelessWidget
    with RubigoScreenMixin<S220Controller> {
  S220Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx20Screen(
      rubigoRouter: controller.rubigoRouter,
      sX20Screen: Screens.s220,
      sX30Screen: Screens.s230,
      onPushButtonPressed: controller.onS230ButtonPressed,
      onPopButtonPressed: controller.onPopButtonPressed,
    );
  }
}
