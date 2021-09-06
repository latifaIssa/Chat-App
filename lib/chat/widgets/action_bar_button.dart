import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  Function function;
  IconData icon;
  ActionButton(this.icon, [this.function]);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.grey[50],
        child: IconButton(
          onPressed: () {
            function();
          },
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          splashRadius: 10,
          splashColor: Colors.lightBlue,
        ),
      ),
    );
  }
}
