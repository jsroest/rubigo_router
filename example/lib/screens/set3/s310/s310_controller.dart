import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S310Controller with RubigoControllerMixin<Screens> {
  S310Controller(this.rubigoRouter);

  final RubigoRouter<Screens> rubigoRouter;
  Future<void> onS320ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s320);
  }
}
