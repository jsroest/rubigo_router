import 'package:example/screens/screens.dart';
import 'package:rubigo_router/rubigo_router.dart';

class S210Controller with RubigoControllerMixin<Screens> {
  S210Controller(this.rubigoRouter);

  final RubigoRouter<Screens> rubigoRouter;

  Future<void> onS220ButtonPressed() async {
    await rubigoRouter.ui.push(Screens.s220);
  }
}
