import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  Color color;
  String label;
  String routeName;
  CustomGestureDetector(this.label, this.routeName, [this.color]);

  @override
  Widget build(BuildContext context) {
    // if (bold) {}
    return GestureDetector(
      onTap: () {
        RouteHelper.routeHelper.goToPage(routeName);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: color == null ? Colors.black : color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
