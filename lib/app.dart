import 'package:flutter/material.dart';
import 'package:flutter_app_navigator2_test/classes/page_stack.dart';
import 'package:flutter_app_navigator2_test/pages/s010_login/s010_login.page.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
//https://github.com/slightfoot/flutter_nav_v2/blob/master/lib/navigator_example.dart
//https://github.com/flutter/flutter/issues/66349

class _AppState extends State<App> {
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();

    return ChangeNotifierProvider<PageStack>(
      create: (_) => PageStack([S010LoginPage.page]),
      child: Builder(
        builder: (BuildContext context) {
          var pageStack = context.watch<PageStack>();
          return MaterialApp(
            navigatorKey: _navigatorKey,
            onGenerateRoute: (_) => null,
            title: 'Flutter Navigator Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            builder: (context, _) {
              return Navigator(
                key: _navigatorKey,
                pages: pageStack.pages,
                onPopPage: (Route<dynamic> route, dynamic result) {
                  pageStack.remove(route.settings as Page);
                  return route.didPop(result);
                },
              );
            },
          );
        },
      ),
    );
  }
}
