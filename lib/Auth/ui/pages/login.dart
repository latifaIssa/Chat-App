import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/reset_password_page.dart';
import 'package:chat_app/Auth/ui/pages/signup.dart';
import 'package:chat_app/Auth/ui/widgets/background_image.dart';
import 'package:chat_app/Auth/ui/widgets/custom_gestureDetector.dart';
import 'package:chat_app/Auth/ui/widgets/custom_textfeild.dart';
import 'package:chat_app/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static final routeName = 'login';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
                    'Hi,',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Login to join the conversation,',
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
                  CustomButton('login', provider.login),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New User?',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      CustomGestureDetector(
                        'signup now',
                        RegisterPage.routeName,
                      ),
                    ],
                  ),
                  CustomGestureDetector(
                    'Forget Password?',
                    ResetPassordPage.routeName,
                    Color(0xFF1e4eff),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
