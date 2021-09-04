import 'package:chat_app/Auth/models/country_model.dart';
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
    double width = MediaQuery.of(context).size.width;
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
                GestureDetector(
                  onTap: () {
                    provider.selectFile();
                  },
                  child: CircleAvatar(
                    // height: 200,
                    // width: 200,
                    backgroundColor: Colors.grey,
                    backgroundImage: provider.file == null
                        ? AssetImage('assets/images/defaultProfileImage.png')
                        : FileImage(
                            provider.file,
                          ),
                    radius: 50,
                  ),
                ),
                CustomrTextFeild('Email', provider.emailController),
                CustomrTextFeild('Password', provider.passwordController),
                CustomrTextFeild('First Name', provider.firstNameController),
                CustomrTextFeild('Last Name', provider.lastNameController),
                provider.countries == null
                    ? Container(
                        child: Text('theres no countries'),
                      )
                    : Container(
                        width: width * 0.8,
                        height: height * 0.065,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<CountryModel>(
                          isDense: true,
                          isExpanded: true,
                          value: provider.selectedCountry == null
                              ? 'Select Country'
                              : provider.selectedCountry,
                          onChanged: (x) {
                            provider.selectCountry(x);
                          },
                          items: provider.countries.map((e) {
                            return DropdownMenuItem<CountryModel>(
                              child: Text(e.name) == null
                                  ? Text('Palestine')
                                  : Text(e.name),
                              value: e,
                            );
                          }).toList(),
                        ),
                      ),
                provider.cities == null
                    ? Container(
                        child: Text('theres no cities'),
                      )
                    : Container(
                        width: width * 0.8,
                        height: height * 0.065,
                        // alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<dynamic>(
                          isDense: true,
                          isExpanded: true,
                          value: provider.selectedCity,
                          onChanged: (x) {
                            provider.selectCity(x);
                          },
                          items: provider.cities.map((e) {
                            return DropdownMenuItem<dynamic>(
                              child: Text(e),
                              value: e,
                            );
                          }).toList(),
                        ),
                      ),
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
