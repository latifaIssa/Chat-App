import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomrTextFeild extends StatelessWidget {
  String label;
  TextEditingController controller;
  CustomrTextFeild(this.label, this.controller);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,
      height: height * 0.065,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      child: TextField(
        controller: this.controller,
        decoration: InputDecoration(
          labelText: this.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
