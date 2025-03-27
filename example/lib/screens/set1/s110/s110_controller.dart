import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S110Controller with RubigoControllerMixin<Screens> {
  S110Controller(this.rubigoRouter);

  final RubigoRouter<Screens> rubigoRouter;

  Future<void> onS120ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s120);
  }
}
