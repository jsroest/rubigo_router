import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/screens/widgets/sx20_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S120Screen extends StatelessWidget
    with RubigoScreenMixin<S120Controller> {
  S120Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx20Screen(
      rubigoRouter: controller.rubigoRouter,
      sX20Screen: Screens.s120,
      sX30Screen: Screens.s130,
      onPushButtonPressed: controller.onS130ButtonPressed,
      onPopButtonPressed: controller.onPopButtonPressed,
    );
  }
}
