import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S320Controller with RubigoControllerMixin<Screens> {
  S320Controller(this.rubigoRouter);

  final RubigoRouter<Screens> rubigoRouter;

  Future<void> onS330ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s330);
  }

  Future<void> onPopButtonPressed() async {
    await rubigoRouter.ui.pop();
  }
}
