import 'package:example/screens/set1/s100/s100_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S100Screen extends StatelessWidget
    with RubigoScreenMixin<S100Controller> {
  S100Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoControllerPopScope(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S100',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity, height: 16),
            ElevatedButton(
              onPressed: controller.onS200ButtonPressed,
              child: const Text('Push S200'),
            ),
          ],
        ),
      ),
    );
  }
}
