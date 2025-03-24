import 'package:rubigo_router/rubigo_router.dart';

/// Adds navigation events and easy access to the [RubigoRouter] to a
/// controller.
mixin RubigoControllerMixin<SCREEN_ID extends Object> {
  /// Provides easy access to the [RubigoRouter] that is in charge of this
  /// controller.
  late RubigoRouter<SCREEN_ID> rubigoRouter;

  /// With this function, the controller is informed that this screen is now on
  /// top of the stack. It is allowed to navigate further in this function.
  Future<void> onTop(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  /// With this function, the controller is informed that this screen is on
  /// top of the stack, and is about to be shown. It is NOT allowed to navigate
  /// further in this function.
  Future<void> willShow(RubigoChangeInfo<SCREEN_ID> changeInfo) async {}

  /// This function can be used to prevent (programmatically) back navigation in
  /// an asynchronous way, for example when you want to check with a backend, if
  /// to allow back navigation.
  /// Be aware that you might want to wire-in a [RubigoBackGesture] widget to
  /// prevent back gestures.
  Future<bool> mayPop() => Future.value(true);

  /// With this function the controller is informed that it is removed from the
  /// stack. The controller can use it to clean up or free memory. It is NOT
  /// allowed to navigate further in this function.
  Future<void> removedFromStack() async {}
}
