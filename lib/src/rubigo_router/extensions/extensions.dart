import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// A collection of extension methods on [ListOfRubigoScreens]
extension ExtensionOnListOfRubigoScreens<SCREEN_ID extends Enum>
    on ListOfRubigoScreens<SCREEN_ID> {
  /// Finds the first [RubigoScreen] in the list with this screenId.
  /// This function throws an error if the screen is not found.
  RubigoScreen<SCREEN_ID> find(SCREEN_ID screenId) =>
      firstWhere((e) => e.screenId == screenId);

  /// Converts this list to a list of ScreenIdl
  List<SCREEN_ID> toListOfScreenId() => map((e) => e.screenId).toList();

  /// Converts this list to a list of screenWidgets
  List<Widget> toListOfWidget() => map((e) => e.screenWidget).toList();
}

/// A collection of extension methods on list of [List<SCREEN_ID>].
extension ExtensionOnListOfScreenId<SCREEN_ID extends Enum> on List<SCREEN_ID> {
  /// Check if there is at least one screen available below the current screen.
  /// This could be an appropriate check before calling [RubigoRouter.pop].
  bool hasScreenBelow() => length > 1;

  /// Check if this specific screenId is available below the current screen.
  /// This could be an appropriate check before calling
  /// [RubigoRouter.popTo].
  bool containsScreenBelow(SCREEN_ID screenId) {
    final lastPageIndex = length - 1;
    final belowLastPageIndex = lastPageIndex - 1;
    final indexFound = lastIndexOf(screenId, belowLastPageIndex);
    return indexFound != -1;
  }

  /// Converts a list of screenId to a list of RubigoScreen
  List<RubigoScreen<SCREEN_ID>> toListOfRubigoScreen(
    ListOfRubigoScreens<SCREEN_ID> availableScreens,
  ) =>
      map((screenId) => availableScreens.find(screenId)).toList();

  /// Converts a list of screenId to a breadcrumbs String.
  /// S100→S200→S300
  String breadCrumbs() => map((e) => e.name).join('→').toUpperCase();
}

/// Extensions on [RubigoScreen]
extension ExtensionOnRubigoScreen on RubigoScreen {
  /// Converts a [RubigoScreen] to a [MaterialPage]
  MaterialPage<void> toMaterialPage() => MaterialPage(
        key: pageKey,
        child: screenWidget,
      );

  /// Converts a [RubigoScreen] to a [CupertinoPage]
  CupertinoPage<void> toCupertinoPage() => CupertinoPage(
        key: pageKey,
        child: screenWidget,
      );
}

/// Extensions on [RubigoRouter]
extension ExtensionOnRubigoRouter<SCREEN_ID extends Enum>
    on RubigoRouter<SCREEN_ID> {
  /// Get the screenId of the current screen
  SCREEN_ID get currentScreenId => screens.last.screenId;
}
