import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function onPressed;
  String label;
  CustomButton(this.label, this.onPressed);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,
      height: height * 0.07,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(label),
        // style: ButtonStyle(backgroundColor: Color(0xFF1e4eff)),
        style: TextButton.styleFrom(
          // primary: Color(0xFF1e4eff),
          backgroundColor: Color(0xFF1e4eff),
        ),
      ),
    );
  }
}
