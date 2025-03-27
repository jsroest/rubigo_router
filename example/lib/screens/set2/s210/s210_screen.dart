import 'package:example/screens/screens.dart';
import 'package:example/screens/set2/s210/s210_controller.dart';
import 'package:example/screens/widgets/sx10_screen.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S210Screen extends StatelessWidget
    with RubigoScreenMixin<S210Controller> {
  S210Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sx10Screen(
      rubigoRouter: controller.rubigoRouter,
      sX10Screen: Screens.s210,
      sX20Screen: Screens.s220,
      onPushButtonPressed: controller.onS220ButtonPressed,
    );
  }
}
