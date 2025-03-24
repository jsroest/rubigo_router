import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Use this class to create a [RubigoRouterDelegate] or use it as a blue-print
/// for your own [RouterDelegate].
class RubigoRouterDelegate<SCREEN_ID extends Object>
    extends RouterDelegate<SCREEN_ID>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  /// Creates a [RubigoRouterDelegate]
  RubigoRouterDelegate({
    required this.rubigoRouter,
    this.observers,
    Page<void> Function(RubigoScreen screen)? rubigoScreenToPage,
  }) : rubigoScreenToPage = rubigoScreenToPage ??= ((e) => e.toMaterialPage()) {
    rubigoRouter.addListener(notifyListeners);
  }

  /// Pass this key to [Navigator.key]
  @override
  GlobalKey<NavigatorState> get navigatorKey => rubigoRouter.navigatorKey;

  // coverage:ignore-start
  @override
  Future<void> setNewRoutePath(SCREEN_ID configuration) async {}

  // coverage:ignore-end

  /// The [RubigoRouter] instance used.
  final RubigoRouter<SCREEN_ID> rubigoRouter;

  /// This function converts a [RubigoScreen] to a [Page]. The default
  /// implementation uses [ExtensionOnRubigoScreen.toMaterialPage].
  final Page<void> Function(RubigoScreen screen) rubigoScreenToPage;

  /// The list of [NavigatorObserver] passed to the [Navigator]. Added for
  /// testing purposes, but may have other use cases.
  final List<NavigatorObserver>? observers;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: observers ?? const <NavigatorObserver>[],
      key: navigatorKey,
      pages: rubigoRouter.screens.map(rubigoScreenToPage).toList(),
      onDidRemovePage: rubigoRouter.onDidRemovePage,
    );
  }
}
