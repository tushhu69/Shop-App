import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(settings: settings, builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}

class CustomPageRouteTranssions extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
