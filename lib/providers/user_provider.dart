import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/helpers/firestore_helper.dart';
import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  AuthProvider provider;
  UserModel user;
  String myId;
  List<UserModel> users;
  getUserFromFirebase() async {
    String userId = AuthHelper.authHelper.getUserId();
    user = await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
    notifyListeners();
  }

  getAllUsers() async {
    users = await FirestoreHelper.firestoreHelper.getAllUsersFromFirestore();
    users.removeWhere((e) => e.id == myId);
    notifyListeners();
  }

//for update profile page
  fillControllers() {
    provider.firstNameController.text = user.fName;
    provider.lastNameController.text = user.lName;
    provider.cityController.text = user.city;
    provider.countryNameController.text = user.country;
    provider.emailController.text = user.email;
  }

  checkLogin() {
    bool isLoggedIn = AuthHelper.authHelper.checkUserLogin();
    if (isLoggedIn) {
      myId = AuthHelper.authHelper.getUserId();
      getAllUsers();
      RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    } else {
      RouteHelper.routeHelper.goToPageWithReplacement(LoginPage.routeName);
    }
  }
}
