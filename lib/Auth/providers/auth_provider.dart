import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/custom_dialog.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  TabController tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  resetControllers() {
    emailController.clear();
    passwordController.clear();
  }

  register() async {
    try {
      await AuthHelper.authHelper
          .signup(emailController.text, passwordController.text);
      await AuthHelper.authHelper.verifyEmail();
      await AuthHelper.authHelper.logout();
      // RouteHelper.routeHelper.goToPageWithReplacement(LoginPage.routeName);
      tabController.animateTo(1);
    } on Exception catch (e) {
      print(e);
    }
    resetControllers();
  }

  login() async {
    await AuthHelper.authHelper
        .signin(emailController.text, passwordController.text)
        .then((value) {
      if (value) {
        //todo handle login
        bool isVerifiedEmail = AuthHelper.authHelper.checkEmailVerification();
        isVerifiedEmail
            ? RouteHelper.routeHelper
                .goToPageWithReplacement(HomePage.routeName)
            : CustomDialog.customDialog.showCustomDialog(
                'You have to verify your email, press ok to send another email',
                sendVericiafion);
        resetControllers();
      } else {
        //todo handel error state
        CustomDialog.customDialog.showCustomDialog('Falid email or password!');
      }
    });
  }

  sendVericiafion() {
    AuthHelper.authHelper.verifyEmail();
    AuthHelper.authHelper.logout();
  }

  ResetPassword() async {
    AuthHelper.authHelper.resetPassword(emailController.text);
    resetControllers();
  }
}
