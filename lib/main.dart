import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Auth/ui/pages/reset_password_page.dart';
import 'Auth/ui/pages/signup.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          ResetPassordPage.routeName: (context) => ResetPassordPage(),
          HomePage.routeName: (context) => HomePage(),
        },
        navigatorKey: RouteHelper.routeHelper.navKey,
        home: FirebaseConfiguration(),
      ),
    ),
  );
}

class FirebaseConfiguration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, AsyncSnapshot<FirebaseApp> dataSnapShot) {
          if (dataSnapShot.hasError) {
            return Scaffold(
              backgroundColor: Colors.red,
              body: Center(
                child: Text(dataSnapShot.error.toString()),
              ),
            );
          }
          if (dataSnapShot.connectionState == ConnectionState.done) {
            // return RegisterPage();
            return LoginPage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
