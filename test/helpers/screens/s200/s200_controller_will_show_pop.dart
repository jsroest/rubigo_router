import 'package:rubigo_navigator/rubigo_navigator.dart';

import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerWillShowPop extends MockController<Screens> {
  @override
  Future<void> willShow(RubigoChangeInfo<Screens> changeInfo) async {
    await rubigoRouter.pop();
  }
}
