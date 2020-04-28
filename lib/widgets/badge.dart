import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;
  Badge({@required this.child,@required this.value, this.color});
  @override
  Widget build(BuildContext context) {
    print('${value.compareTo('1')}');
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        value.compareTo('0')==0?Container():Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color != null ? color : Theme.of(context).accentColor),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
