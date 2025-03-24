import 'package:flutter/widgets.dart';
import 'package:rubigo_router/rubigo_router.dart';

/// Check if the current topmost route is a pageless route or a
/// page(full)route.
bool currentRouteIsPage(RubigoRouter rubigoRouter) {
  var isPage = false;
  final context = rubigoRouter.navigatorKey.currentContext;
  if (context == null) {
    return false;
  }
  // https://stackoverflow.com/questions/50817086/how-to-check-which-the-current-route-is
  Navigator.of(context).popUntil(
    (route) {
      if (route.settings is Page) {
        isPage = true;
      }
      return true;
    },
  );
  return isPage;
}

String getName(Object object) {
  return object is Enum ? object.name : object.toString();
}
