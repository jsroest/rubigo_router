import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// A screen widget with a corresponding controller, which may implement a
/// [RubigoControllerMixin] (but doesn't have to). This set is uniquely
/// identified by a [SCREEN_ID].
@immutable
class RubigoScreen<SCREEN_ID extends Object> {
  /// Creates a [RubigoScreen]
  RubigoScreen({
    required this.screenId,
    required Widget Function() getScreenWidget,
    required Object Function() getController,
    required this.getRubigoRouter,
  })  : _getScreenWidget = getScreenWidget,
        _getController = getController,
        pageKey = ValueKey(screenId);

  /// A unique key, based on the screenId. This key is used for [Page.key].
  final ValueKey<SCREEN_ID> pageKey;

  /// The unique identifier for this [RubigoScreen]
  final SCREEN_ID screenId;

  final Widget Function() _getScreenWidget;

  /// The widget that represents this screen.
  Widget getScreenWidget() {
    final screenWidget = _getScreenWidget();
    if (screenWidget is RubigoScreenMixin) {
      (screenWidget as RubigoScreenMixin).controller = getController();
    }
    return screenWidget;
  }

  final Object Function() _getController;

  /// Return the instance of the controller. You can use any dependency
  /// injection package in this function, as long as it always returns the same
  /// instance for the controller (singleton).
  Object getController() {
    final controller = _getController();
    if (controller is RubigoControllerMixin) {
      controller.rubigoRouter = getRubigoRouter();
    }
    return controller;
  }

  /// Return the instance of the rubigoRouter. You can use any dependency
  /// injection package in this function, as long as it always returns the same
  /// instance for the rubigoRouter (singleton).
  final RubigoRouter<SCREEN_ID> Function() getRubigoRouter;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RubigoScreen &&
        other.runtimeType == runtimeType &&
        other.screenId == screenId;
  }

  @override
  int get hashCode => screenId.hashCode;
}
