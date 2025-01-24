import 'package:example/screens/set1/s100/s100_controller.dart';
import 'package:example/screens/set1/s100/s100_screen.dart';
import 'package:example/screens/set1/s110/s110_controller.dart';
import 'package:example/screens/set1/s110/s110_screen.dart';
import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/screens/set1/s120/s120_screen.dart';
import 'package:example/screens/set1/s130/s130_controller.dart';
import 'package:example/screens/set1/s130/s130_screen.dart';
import 'package:example/screens/set2/s200/s200_controller.dart';
import 'package:example/screens/set2/s200/s200_screen.dart';
import 'package:example/screens/set2/s210/s210_controller.dart';
import 'package:example/screens/set2/s210/s210_screen.dart';
import 'package:example/screens/set2/s220/s220_controller.dart';
import 'package:example/screens/set2/s220/s220_screen.dart';
import 'package:example/screens/set2/s230/s230_controller.dart';
import 'package:example/screens/set2/s230/s230_screen.dart';
import 'package:example/screens/set3/s300/s300_controller.dart';
import 'package:example/screens/set3/s300/s300_screen.dart';
import 'package:example/screens/set3/s310/s310_controller.dart';
import 'package:example/screens/set3/s310/s310_screen.dart';
import 'package:example/screens/set3/s320/s320_controller.dart';
import 'package:example/screens/set3/s320/s320_screen.dart';
import 'package:example/screens/set3/s330/s330_controller.dart';
import 'package:example/screens/set3/s330/s330_screen.dart';
import 'package:example/screens/splash_screen/splash_controller.dart';
import 'package:example/screens/splash_screen/splash_screen.dart';
import 'package:rubigo_router/rubigo_router.dart';

// All screens are defined here.
enum Screens {
  splashScreen,
  s100,
  s110,
  s120,
  s130,
  s200,
  s210,
  s220,
  s230,
  s300,
  s310,
  s320,
  s330,
}

// A simple service locator to hold controllers.
final holder = RubigoHolder();

// All available screens are defined here.
final ListOfRubigoScreens<Screens> availableScreens = [
  RubigoScreen(
    Screens.splashScreen,
    SplashScreen(),
    () => holder.getOrCreate(SplashController.new),
  ),
  RubigoScreen(
    Screens.s100,
    S100Screen(),
    () => holder.getOrCreate(S100Controller.new),
  ),
  RubigoScreen(
    Screens.s110,
    S110Screen(),
    () => holder.getOrCreate(S110Controller.new),
  ),
  RubigoScreen(
    Screens.s120,
    S120Screen(),
    () => holder.getOrCreate(S120Controller.new),
  ),
  RubigoScreen(
    Screens.s130,
    const S130Screen(),
    () => holder.getOrCreate(S130Controller.new),
  ),
  RubigoScreen(
    Screens.s200,
    S200Screen(),
    () => holder.getOrCreate(S200Controller.new),
  ),
  RubigoScreen(
    Screens.s210,
    S210Screen(),
    () => holder.getOrCreate(S210Controller.new),
  ),
  RubigoScreen(
    Screens.s220,
    S220Screen(),
    () => holder.getOrCreate(S220Controller.new),
  ),
  RubigoScreen(
    Screens.s230,
    const S230Screen(),
    () => holder.getOrCreate(S230Controller.new),
  ),
  RubigoScreen(
    Screens.s300,
    S300Screen(),
    () => holder.getOrCreate(S300Controller.new),
  ),
  RubigoScreen(
    Screens.s310,
    S310Screen(),
    () => holder.getOrCreate(S310Controller.new),
  ),
  RubigoScreen(
    Screens.s320,
    S320Screen(),
    () => holder.getOrCreate(S320Controller.new),
  ),
  RubigoScreen(
    Screens.s330,
    const S330Screen(),
    () => holder.getOrCreate(S330Controller.new),
  ),
];
