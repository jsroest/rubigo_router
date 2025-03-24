import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

// This AppBar shows a title and the current screen stack as breadcrumbs.
class AppBarTitleBreadCrumbs<SCREEN_ID extends Object> extends StatelessWidget {
  const AppBarTitleBreadCrumbs({
    required this.title,
    required this.rubigoRouter,
    super.key,
  });

  final String title;
  final RubigoRouter rubigoRouter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen: $title'),
        ListenableBuilder(
          listenable: rubigoRouter,
          builder: (context, _) {
            return Text(
              'Screen stack: ${rubigoRouter.screens.toListOfScreenId().breadCrumbs()}',
              style: TextTheme.of(context).bodyMedium,
            );
          },
        ),
      ],
    );
  }
}
