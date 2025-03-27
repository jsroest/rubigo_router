import 'package:example/screens/screens.dart';
import 'package:example/widgets/app_bar_title_breadcrumbs.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class Sx30Screen extends StatelessWidget {
  const Sx30Screen({
    required this.rubigoRouter,
    required this.sX10Screen,
    required this.sX20Screen,
    required this.sX30Screen,
    required this.sX40Screen,
    required this.allowBackGesture,
    required this.mayPop,
    required this.confirmPop,
    required this.onPushSx040ButtonPressed,
    required this.onPopButtonPressed,
    required this.onPopToSx10ButtonPressed,
    required this.onRemoveSx10ButtonPressed,
    required this.onRemoveSx20ButtonPressed,
    required this.onResetStackButtonPressed,
    required this.onToSetAButtonPressed,
    required this.toSetAButtonText,
    required this.onToSetBButtonPressed,
    required this.toSetBButtonText,
    super.key,
  });

  final RubigoRouter<Screens> rubigoRouter;
  final Screens sX10Screen;
  final Screens sX20Screen;
  final Screens sX30Screen;
  final Screens sX40Screen;
  final ValueNotifier<bool> allowBackGesture;
  final ValueNotifier<bool> mayPop;
  final ValueNotifier<bool> confirmPop;
  final VoidCallback onPushSx040ButtonPressed;
  final VoidCallback onPopButtonPressed;
  final VoidCallback onPopToSx10ButtonPressed;
  final VoidCallback onRemoveSx10ButtonPressed;
  final VoidCallback onRemoveSx20ButtonPressed;
  final VoidCallback onResetStackButtonPressed;
  final VoidCallback onToSetAButtonPressed;
  final String toSetAButtonText;
  final VoidCallback onToSetBButtonPressed;
  final String toSetBButtonText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: allowBackGesture,
      builder: (context, value, child) {
        return RubigoBackGesture(
          rubigoRouter: rubigoRouter,
          allowBackGesture: value,
          child: Scaffold(
            appBar: AppBar(
              leading: rubigoBackButton(context, rubigoRouter),
              title: AppBarTitleBreadCrumbs(
                title: sX30Screen.name.toUpperCase(),
                rubigoRouter: rubigoRouter,
              ),
            ),
            body: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  const Text('Allow back gesture'),
                  ValueListenableBuilder(
                    valueListenable: allowBackGesture,
                    builder: (context, value, _) => Switch(
                      value: value,
                      onChanged: (value) => allowBackGesture.value = value,
                    ),
                  ),
                  const Text('mayPop'),
                  ValueListenableBuilder(
                    valueListenable: mayPop,
                    builder: (context, value, _) => Switch(
                      value: value,
                      onChanged: (value) => mayPop.value = value,
                    ),
                  ),
                  const Text('Confirm pop in mayPop'),
                  ValueListenableBuilder(
                    valueListenable: confirmPop,
                    builder: (context, value, _) => Switch(
                      value: value,
                      onChanged: (value) => confirmPop.value = value,
                    ),
                  ),
                  NavigateButton(
                    rubigoRouter: rubigoRouter,
                    isEnabled: (_) => true,
                    onPressed: onPushSx040ButtonPressed,
                    child: Text('Push ${sX40Screen.name.toUpperCase()}'),
                  ),
                  NavigateButton(
                    rubigoRouter: rubigoRouter,
                    isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                    onPressed: onPopButtonPressed,
                    child: const Text('Pop'),
                  ),
                  NavigateButton(
                    rubigoRouter: rubigoRouter,
                    isEnabled: (screenStack) =>
                        screenStack.containsScreenBelow(sX10Screen),
                    onPressed: onPopToSx10ButtonPressed,
                    child: Text('PopTo ${sX10Screen.name.toUpperCase()}'),
                  ),
                  NavigateButton(
                    rubigoRouter: rubigoRouter,
                    isEnabled: (screenStack) =>
                        screenStack.containsScreenBelow(sX10Screen),
                    onPressed: onRemoveSx10ButtonPressed,
                    child: Text('Remove ${sX10Screen.name.toUpperCase()}'),
                  ),
                  NavigateButton(
                    rubigoRouter: rubigoRouter,
                    isEnabled: (screenStack) =>
                        screenStack.containsScreenBelow(sX20Screen),
                    onPressed: onRemoveSx20ButtonPressed,
                    child: Text('Remove ${sX20Screen.name.toUpperCase()}'),
                  ),
                  ElevatedButton(
                    onPressed: onResetStackButtonPressed,
                    child: const Text('Reset stack'),
                  ),
                  ElevatedButton(
                    onPressed: onToSetAButtonPressed,
                    child: Text(toSetAButtonText),
                  ),
                  ElevatedButton(
                    onPressed: onToSetBButtonPressed,
                    child: Text(toSetBButtonText),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
