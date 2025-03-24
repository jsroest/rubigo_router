import 'package:rubigo_router/rubigo_router.dart';

/// A list of RubigoScreen.
typedef ListOfRubigoScreens<SCREEN_ID extends Object>
    = List<RubigoScreen<SCREEN_ID>>;

/// A function to log navigation events, using your favorite logger
typedef LogNavigation = Future<void> Function(String message);

/// A function to execute, when the current navigation finishes.
typedef PostNavigationCallback = Future<void> Function();
