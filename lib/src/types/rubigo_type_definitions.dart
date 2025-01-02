import 'package:flutter/widgets.dart';
import 'package:rubigo_navigator/src/rubigo_screen.dart';

typedef TypeRubigoScreen<SCREEN_ID extends Enum> = RubigoScreen<SCREEN_ID>;

typedef ListOfRubigoScreens<SCREEN_ID extends Enum>
    = List<TypeRubigoScreen<SCREEN_ID>>;

typedef LogNavigation = Future<void> Function(String message);

typedef ScreenListToPageList = List<Page<void>> Function(List<Widget> screen);

typedef BusyWrapper = Future<void> Function(Future<void> Function() function);
