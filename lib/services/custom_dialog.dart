import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  CustomDialog._();
  static CustomDialog customDialog = CustomDialog._();
  showCustomDialog(String msg, [Function fun]) {
    showDialog(
        context: RouteHelper.routeHelper.navKey.currentContext,
        builder: (_) {
          return AlertDialog(
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () {
                  if (fun == null) {
                    RouteHelper.routeHelper.back();
                  } else {
                    fun();
                    RouteHelper.routeHelper.back();
                  }
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }
}
