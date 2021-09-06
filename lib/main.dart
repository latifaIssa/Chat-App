import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/Auth/ui/pages/splash_screen.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/chat/pages/profile_page.dart';
import 'package:chat_app/chat/pages/update_profile.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Auth/ui/pages/reset_password_page.dart';
import 'Auth/ui/pages/signup.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
      )
    ],
    child: MaterialApp(
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        ResetPassordPage.routeName: (context) => ResetPassordPage(),
        HomePage.routeName: (context) => HomePage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        UpdateProfile.routeName: (context) => UpdateProfile(),
      },
      navigatorKey: RouteHelper.routeHelper.navKey,
      home: FirebaseConfiguration(),
    ),
  ));
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
            return SplashScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
