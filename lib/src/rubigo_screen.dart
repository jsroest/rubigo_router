import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Wires a screen widget and a controller together with a unique id.
@immutable
class RubigoScreen<SCREEN_ID extends Enum> {
  /// Creates a RubigoScreen
  RubigoScreen(
    this.screenId,
    this.screenWidget,
    this.getController,
  ) : pageKey = ValueKey(screenId);

  /// A unique pageKey, based on the screenId. This key is normally passed to
  /// the constructor of the [MaterialPage] or [CupertinoPage] as the key
  /// parameter.
  final ValueKey<SCREEN_ID> pageKey;

  /// The unique identifier for this [RubigoScreen]
  final SCREEN_ID screenId;

  /// The widget that represents this screen. By default this widget is wrapped
  /// in a [MaterialPage], but you can pass your own rubigoScreenToPage function
  /// in the rubigoScreenToPage parameter in the [RubigoRouterDelegate]
  /// constructor.
  final Widget screenWidget;

  /// Return the instance of the controller. You can use any dependency
  /// injection package in this function, as long as it always returns the same
  /// instance for the controller (singleton).
  final Object Function() getController;

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
