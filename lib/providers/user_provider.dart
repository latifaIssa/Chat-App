import 'dart:io';

import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/helpers/firestorage_helper.dart';
import 'package:chat_app/Auth/helpers/firestore_helper.dart';
import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  AuthProvider provider;
  UserModel user;
  String myId;
  List<UserModel> users = [];
  List<UserModel> recentUsers = [];

  getUserFromFirebase() async {
    String userId = AuthHelper.authHelper.getUserId();
    user = await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
    notifyListeners();
  }

  getAllUsers() async {
    users = await FirestoreHelper.firestoreHelper.getAllUsersFromFirestore();
    users.removeWhere((e) => e.id == myId);
    recentUsers.removeWhere((e) => e.id == myId);
    notifyListeners();
  }

//for update profile page
  fillControllers() {
    firstNameController.text = user.fName;
    lastNameController.text = user.lName;
    cityController.text = user.city;
    countryNameController.text = user.country;
  }

  File updatedfile;
  captureUpdateProfileImage() async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.updatedfile = File(file.path);
    notifyListeners();
  }

  updateProfile() async {
    String imageUrl;
    if (updatedfile != null) {
      imageUrl = await FirebaseStorageHelper.firebaseStorageHelper
          .uploadImage(updatedfile);
    }
    UserModel userModel = imageUrl == null
        ? UserModel(
            city: cityController.text,
            country: countryNameController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id,
          )
        : UserModel(
            city: cityController.text,
            country: countryNameController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id,
            imageUrl: imageUrl);

    await FirestoreHelper.firestoreHelper.updateProfile(userModel);
    getUserFromFirebase();
    Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop();
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
