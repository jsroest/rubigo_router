import 'package:example/screens/screens.dart';
import 'package:example/screens/set1/s300/s300_controller.dart';
import 'package:example/widgets/app_bar_title.dart';
import 'package:example/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S300Screen extends StatelessWidget
    with RubigoScreenMixin<S300Controller> {
  S300Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RubigoControllerPopScope(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: 'S300',
            screens: controller.rubigoRouter.screens,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                onPressed: controller.onS400ButtonPressed,
                child: const Text('Push S400'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) => screenStack.hasScreenBelow(),
                onPressed: controller.onPopButtonPressed,
                child: const Text('Pop'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s100),
                onPressed: controller.onPopToS100ButtonPressed,
                child: const Text('PopTo S100'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s200),
                onPressed: controller.onRemoveS200ButtonPressed,
                child: const Text('Remove S200'),
              ),
              const SizedBox(
                height: 16,
              ),
              NavigateButton(
                screens: controller.rubigoRouter.screens,
                isEnabled: (screenStack) =>
                    screenStack.containsScreenBelow(Screens.s100),
                onPressed: controller.onRemoveS100ButtonPressed,
                child: const Text('Remove S100'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.resetStack,
                child: const Text('Reset stack'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.toSet2,
                child: const Text('Replace stack with set 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
