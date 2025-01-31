import '../../mock_controller/mock_controller.dart';
import '../screens.dart';

class S400RubigoController extends MockController<Screens> {
  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    return false;
  }
}

class S400Controller {}
