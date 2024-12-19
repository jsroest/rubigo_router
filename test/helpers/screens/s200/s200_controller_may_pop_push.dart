import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../screens.dart';

class S200ControllerMayPopPush extends RubigoController<Screens> {
  @override
  Future<bool> mayPop() async {
    await navigator.pop();
    return false;
  }
}