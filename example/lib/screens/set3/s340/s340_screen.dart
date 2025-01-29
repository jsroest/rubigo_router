import 'package:example/screens/screens.dart';
import 'package:example/screens/widgets/sx40_screen.dart';
import 'package:flutter/material.dart';

class S340Screen extends StatelessWidget {
  const S340Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Sx040Screen(
      sX40Screen: Screens.s340,
    );
  }
}
