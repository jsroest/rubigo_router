import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

// This AppBar shows a title and the current screen stack as breadcrumbs.
class AppBarTitle<SCREEN_ID extends Enum> extends StatelessWidget {
  const AppBarTitle({
    required this.title,
    required this.screens,
    super.key,
  });

  final String title;
  final ValueListenable<ListOfRubigoScreens<SCREEN_ID>> screens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ValueListenableBuilder(
          valueListenable: screens,
          builder: (context, value, child) =>
              Text(screens.value.toListOfScreenId().breadCrumbs()),
        ),
      ],
    );
  }
}
