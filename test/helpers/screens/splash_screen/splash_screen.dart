import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class SplashScreen extends StatelessWidget with RubigoScreenMixin {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          child: Icon(Icons.emoji_people),
        ),
      ),
    );
  }
}
