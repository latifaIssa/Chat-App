import 'dart:io';

import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/helpers/firestorage_helper.dart';
import 'package:chat_app/Auth/helpers/firestore_helper.dart';
import 'package:chat_app/Auth/models/country_model.dart';
import 'package:chat_app/Auth/models/register_requiest.dart';
import 'package:chat_app/Auth/ui/pages/login.dart';
import 'package:chat_app/chat/pages/home_page.dart';
import 'package:chat_app/services/custom_dialog.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    getCountriesFromFirestore();
  }
  TabController tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();

  resetControllers() {
    emailController.clear();
    passwordController.clear();
  }

//select country and city
  List<CountryModel> countries;
  List<dynamic> cities = [];
  CountryModel selectedCountry;
  String selectedCity;
  selectCountry(CountryModel countryModel) {
    this.selectedCountry = countryModel;
    this.cities = countryModel.cities;
    selectCity(cities.first.toString());
    notifyListeners();
  }

  selectCity(dynamic city) {
    this.selectedCity = city;
    notifyListeners();
  }

  getCountriesFromFirestore() async {
    List<CountryModel> countries =
        await FirestoreHelper.firestoreHelper.getAllCountries();
    this.countries = countries;
    selectCountry(countries.first);
    notifyListeners();
  }

//upload image to firebase
  File file;
  selectFile() async {
    XFile imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    this.file = File(imageFile.path);
    print(imageFile.path);
    notifyListeners();
  }

  register() async {
    try {
      if (file == null)
        CustomDialog.customDialog
            .showCustomDialog('please select profile photo');
      else if (firstNameController.text == '' || lastNameController.text == '')
        CustomDialog.customDialog
            .showCustomDialog('first name and last name are required');
      else {
        UserCredential userCredential = await AuthHelper.authHelper
            .signup(emailController.text, passwordController.text);
        await AuthHelper.authHelper.verifyEmail();
        String imageUrl =
            await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
        RegisterRequest registerRequest = RegisterRequest(
          id: userCredential.user.uid,
          email: emailController.text,
          password: passwordController.text,
          city: selectedCity,
          country: selectedCountry.name,
          fName: firstNameController.text,
          lName: lastNameController.text,
          imageUrl: imageUrl,
        );
        await FirestoreHelper.firestoreHelper
            .addUserToFirestore(registerRequest);

        await logOut();
      }
    } on Exception catch (e) {
      print(e);
    }
    resetControllers();
  }

  login() async {
    UserCredential userCredential = await AuthHelper.authHelper
        .signin(emailController.text, passwordController.text);
    FirestoreHelper.firestoreHelper
        .getUserFromFirestore(userCredential.user.uid);
    RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);

    resetControllers();
  }

  sendVericiafion() {
    AuthHelper.authHelper.verifyEmail();
    AuthHelper.authHelper.logout();
  }

  resetPassword() async {
    AuthHelper.authHelper.resetPassword(emailController.text);
    resetControllers();
  }

  logOut() async {
    await AuthHelper.authHelper.logout();
    resetControllers();
    firstNameController.clear();
    lastNameController.clear();
    RouteHelper.routeHelper.goToPageWithReplacement(LoginPage.routeName);
  }
}
