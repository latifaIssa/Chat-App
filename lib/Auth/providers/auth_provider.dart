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

//register and login
  register() async {
    try {
      if (lastNameController.text == '' || firstNameController.text == '')
        CustomDialog.customDialog.showCustomDialog(
            'First name and last name are required, please fill them');
      else if (file == null)
        CustomDialog.customDialog
            .showCustomDialog('profile photo is required ');
      else {
        UserCredential userCredential = await AuthHelper.authHelper
            .signup(emailController.text, passwordController.text);
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
        await AuthHelper.authHelper.verifyEmail();
        await AuthHelper.authHelper.logout();
        await RouteHelper.routeHelper.goToPage(LoginPage.routeName);
        await FirestoreHelper.firestoreHelper
            .addUserToFirestore(registerRequest);
      }

      // tabController.animateTo(1);
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
