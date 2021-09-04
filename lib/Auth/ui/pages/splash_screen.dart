import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        Provider.of<AuthProvider>(context, listen: false).checkLogin();
      },
    );
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
