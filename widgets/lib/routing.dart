import 'package:flutter/material.dart';

PageRouteBuilder Function(RouteSettings settings) generateRoutes(
        Map<String,
                Widget Function(BuildContext context, RouteSettings settings)>
            routes) =>
    (RouteSettings settings) {
      // print('showing ${settings.name}');

      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          if (routes.containsKey(settings.name)) {
            return routes[settings.name]!(context, settings);
          }
          //return routes[settings.name]!(context, settings);
          throw Exception('Invalid route: ${settings.name}');
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return child;
        },
      );
    };

PageRouteBuilder Function(RouteSettings settings) generateRoutesWithRegexp(
        Map<String,
                Widget Function(BuildContext context, RouteSettings settings)>
            routes) =>
    (RouteSettings settings) {
      // print('showing ${settings.name}');

      for (var route in routes.keys) {
        final RegExp pattern = RegExp(route);
        final match = pattern.firstMatch(settings.name!);
        if (match != null) {
          final String execId = match.group(1)!;
          final String docId = match.group(2)!;
          // return MaterialPageRoute(
          //   builder: (BuildContext context) => routes[route]!(context, settings),
          //   settings: settings,
          // );

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              if (routes.containsKey(settings.name)) {
                //return routes[settings.name]!(context, settings);
                return routes[route]!(
                    context,
                    RouteSettings(
                        name: settings.name,
                        arguments: {'execId': execId, 'docId': docId}));
              }
              //return routes[settings.name]!(context, settings);
              throw Exception('Invalid route: ${settings.name}');
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return child;
            },
          );
        }
      }
      throw Exception('Invalid route: ${settings.name}');
    };

String _routePattern(String route) {
  return route.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) => r'(\w+)');
}

RouteFactory generateRoutes2(
    Map<String, Widget Function(BuildContext, RouteSettings)> routeBuilders) {
  return (RouteSettings settings) {
    for (final route in routeBuilders.keys) {
      final RegExp pattern = RegExp('^${_routePattern(route)}\$');
      final match = pattern.firstMatch(settings.name!);
      if (match != null) {
        final builder = routeBuilders[route]!;
        return MaterialPageRoute(
          builder: (BuildContext context) => builder(context, settings),
          settings: settings,
        );
      }
    }

    // If no match is found, return an error page.
    return MaterialPageRoute(
      builder: (BuildContext context) => ErrorPage(),
      settings: settings,
    );
  };
}


// PageRouteBuilder generateRoute(RouteSettings settings) {
//   WidgetBuilder builder;
//   // print('showing ${settings.name}');
//   switch (settings.name) {
//     case '/providers':
//       builder = (BuildContext context) => ProvidersPage();
//       break;
//     case '/auth':
//       builder = (BuildContext context) => AuthPage();
//       break;
//     case '/widgets':
//       builder = (BuildContext context) => WidgetsPage();
//       break;
//     default:
//       throw Exception('Invalid route: ${settings.name}');
//   }

//   return PageRouteBuilder(
//     settings: settings,
//     pageBuilder: (BuildContext context, Animation<double> animation,
//         Animation<double> secondaryAnimation) {
//       return builder(context);
//     },
//     transitionsBuilder: (BuildContext context, Animation<double> animation,
//         Animation<double> secondaryAnimation, Widget child) {
//       return child;
//     },
//   );
// }
