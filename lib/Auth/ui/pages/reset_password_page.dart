import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/Auth/ui/widgets/custom_textfeild.dart';
import 'package:chat_app/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassordPage extends StatelessWidget {
  static final routeName = 'reset';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Consumer<AuthProvider>(
        builder: (contex, provider, x) {
          return Center(
            child: Column(
              children: [
                CustomrTextFeild('Email', provider.emailController),
                CustomButton('Reset password', provider.resetPassword),
              ],
            ),
          );
        },
      ),
    );
  }
}
