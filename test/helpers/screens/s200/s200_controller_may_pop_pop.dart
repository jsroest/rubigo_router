import '../mocks/mock_controller.dart';
import '../screens.dart';

class S200ControllerMayPopPop extends MockController<Screens> {
  @override
  Future<bool> mayPop() async {
    await rubigoRouter.push(Screens.s300);
    return false;
  }
}
