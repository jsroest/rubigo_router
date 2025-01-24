import 'package:example/screens/set2/s200/s200_controller.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S200Screen extends StatelessWidget
    with RubigoScreenMixin<S200Controller> {
  S200Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleBreadCrumbs(
          title: 'S200',
          screens: controller.rubigoRouter.screens,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity, height: 8),
          ElevatedButton(
            onPressed: controller.onS210ButtonPressed,
            child: const Text('Push S210'),
          ),
        ],
      ),
    );
  }
}
