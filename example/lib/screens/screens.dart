import 'package:example/screens/set1/s110/s110_controller.dart';
import 'package:example/screens/set1/s110/s110_screen.dart';
import 'package:example/screens/set1/s120/s120_controller.dart';
import 'package:example/screens/set1/s120/s120_screen.dart';
import 'package:example/screens/set1/s130/s130_controller.dart';
import 'package:example/screens/set1/s130/s130_screen.dart';
import 'package:example/screens/set1/s140/s140_controller.dart';
import 'package:example/screens/set1/s140/s140_screen.dart';
import 'package:example/screens/set2/s210/s210_controller.dart';
import 'package:example/screens/set2/s210/s210_screen.dart';
import 'package:example/screens/set2/s220/s220_controller.dart';
import 'package:example/screens/set2/s220/s220_screen.dart';
import 'package:example/screens/set2/s230/s230_controller.dart';
import 'package:example/screens/set2/s230/s230_screen.dart';
import 'package:example/screens/set2/s240/s240_controller.dart';
import 'package:example/screens/set2/s240/s240_screen.dart';
import 'package:example/screens/set3/s310/s310_controller.dart';
import 'package:example/screens/set3/s310/s310_screen.dart';
import 'package:example/screens/set3/s320/s320_controller.dart';
import 'package:example/screens/set3/s320/s320_screen.dart';
import 'package:example/screens/set3/s330/s330_controller.dart';
import 'package:example/screens/set3/s330/s330_screen.dart';
import 'package:example/screens/set3/s340/s340_controller.dart';
import 'package:example/screens/set3/s340/s340_screen.dart';
import 'package:example/screens/splash_screen/splash_controller.dart';
import 'package:example/screens/splash_screen/splash_screen.dart';
import 'package:rubigo_router/rubigo_router.dart';

// All screens are defined here.
enum Screens {
  splashScreen,
  s110,
  s120,
  s130,
  s140,
  s210,
  s220,
  s230,
  s240,
  s310,
  s320,
  s330,
  s340,
}

// A simple service locator to hold controllers.
final holder = RubigoHolder();

RubigoScreen<Screens> screenProvider(
  Screens screenId,
) {
  switch (screenId) {
    case Screens.splashScreen:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: SplashScreen.new,
        controller: () =>
            holder.getOrCreate<SplashController>(SplashController.new),
      );
    case Screens.s110:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S110Screen.new,
        controller: () => holder.getOrCreate<S110Controller>(
          () => S110Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s120:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S120Screen.new,
        controller: () => holder.getOrCreate<S120Controller>(
          () => S120Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s130:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S130Screen.new,
        controller: () => holder.getOrCreate<S130Controller>(
          () => S130Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s140:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S140Screen.new,
        controller: () =>
            holder.getOrCreate<S140Controller>(S140Controller.new),
      );
    case Screens.s210:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S210Screen.new,
        controller: () => holder.getOrCreate<S210Controller>(
          () => S210Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s220:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S220Screen.new,
        controller: () => holder.getOrCreate<S220Controller>(
          () => S220Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s230:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S230Screen.new,
        controller: () => holder.getOrCreate<S230Controller>(
          () => S230Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s240:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S240Screen.new,
        controller: () =>
            holder.getOrCreate<S240Controller>(S240Controller.new),
      );
    case Screens.s310:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S310Screen.new,
        controller: () => holder.getOrCreate<S310Controller>(
          () => S310Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s320:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S320Screen.new,
        controller: () => holder.getOrCreate<S320Controller>(
          () => S320Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s330:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S330Screen.new,
        controller: () => holder.getOrCreate<S330Controller>(
          () => S330Controller(holder.get<RubigoRouter<Screens>>()),
        ),
      );
    case Screens.s340:
      return RubigoScreen(
        screenId: screenId,
        screenWidget: S340Screen.new,
        controller: () =>
            holder.getOrCreate<S340Controller>(S340Controller.new),
      );
  }
}
