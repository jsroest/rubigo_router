import 'package:flutter/foundation.dart';
import 'package:rubigo_router/rubigo_router.dart';

import 'callbacks.dart';

class MockController<SCREEN_ID extends Enum>
    with RubigoControllerMixin<SCREEN_ID> {
  MockController(this.rubigoRouter);

  final RubigoRouter<SCREEN_ID> rubigoRouter;
  SCREEN_ID? onTopPush;
  SCREEN_ID? willShowPush;
  SCREEN_ID? removedFromStackPush;
  bool mayPopValue = true;
  final List<CallBack> callBackHistory = [];

  @mustCallSuper
  @override
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    await super.onTop(changeInfo);
    callBackHistory.add(OnTopCallBack(changeInfo));
    if (onTopPush != null) {
      await rubigoRouter.push(onTopPush!);
    }
  }

  @mustCallSuper
  @override
  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {
    await super.willShow(changeInfo);
    callBackHistory.add(WillShowCallBack(changeInfo));
    if (willShowPush != null) {
      await rubigoRouter.push(willShowPush!);
    }
  }

  @mustCallSuper
  @override
  Future<void> removedFromStack() async {
    await super.removedFromStack();
    callBackHistory.add(RemovedFromStackCallBack());
    if (removedFromStackPush != null) {
      await rubigoRouter.push(removedFromStackPush!);
    }
  }

  @mustCallSuper
  @override
  Future<bool> mayPop() async {
    await super.mayPop();
    callBackHistory.add(MayPopCallBack(mayPop: mayPopValue));
    return mayPopValue;
  }
}
