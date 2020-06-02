import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);


  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(position: offsetAnimation, child: child,);
    
//    var tween=Tween<double>(begin: 0.0,end: 1.0);
//    var opacity=animation.drive(tween);
//    return FadeTransition(opacity: opacity,child: child,);
  }

}
