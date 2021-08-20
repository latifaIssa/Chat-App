import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/Auth/ui/widgets/background_image.dart';
import 'package:chat_app/Auth/ui/widgets/custom_gestureDetector.dart';
import 'package:chat_app/Auth/ui/widgets/custom_textfeild.dart';
import 'package:chat_app/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static final routeName = 'register';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (contex, provider, x) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BackgroundImage(),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'Register now to join the conversation,',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                CustomrTextFeild('Email', provider.emailController),
                CustomrTextFeild('Password', provider.passwordController),
                CustomButton('Register', provider.register),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'if you have account,',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    CustomGestureDetector(
                      'Login now',
                      LoginPage.routeName,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
