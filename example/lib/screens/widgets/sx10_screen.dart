import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx10Screen extends StatelessWidget with RubigoControllerMixin<Screens> {
  const Sx10Screen({
    required this.rubigoRouter,
    required this.sX10Screen,
    required this.sX20Screen,
    required this.onPushButtonPressed,
    super.key,
  });

  final RubigoRouter<Screens> rubigoRouter;
  final Screens sX10Screen;
  final Screens sX20Screen;
  final VoidCallback onPushButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: rubigoBackButton(context, rubigoRouter),
        title: AppBarTitleBreadCrumbs(
          title: sX10Screen.name.toUpperCase(),
          rubigoRouter: rubigoRouter,
        ),
      ),
      body: Center(
        child: Column(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPushButtonPressed,
              child: Text('Push ${sX20Screen.name.toUpperCase()}'),
            ),
          ],
        ),
      ),
    );
  }
}
