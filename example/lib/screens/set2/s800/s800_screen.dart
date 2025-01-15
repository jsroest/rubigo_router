import 'package:example/holder.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S800Screen extends StatelessWidget {
  const S800Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoRouterPopScope(
      rubigoRouter: holder.get<RubigoRouter>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S800'),
        ),
        body: const Placeholder(),
      ),
    );
  }
}
