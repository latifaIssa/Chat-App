import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/chat/widgets/action_bar_button.dart';
import 'package:chat_app/chat/widgets/item_widget.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendInfo extends StatefulWidget {
  static final routeName = 'friendInfo';

  @override
  _FriendInfoState createState() => _FriendInfoState();
}

class _FriendInfoState extends State<FriendInfo> {
  UserModel user;

  void initState() {
    super.initState();
    this.user = Provider.of<UserProvider>(context, listen: false).friend;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        actions: [
          ActionButton(
            Icons.arrow_back_ios_new,
            Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            user.imageUrl == null
                ? CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/defaultProfileImage.png'),
                    radius: 70,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      user.imageUrl,
                    ),
                    radius: 70,
                  ),
            ItemWidget('Email', user.email),
            ItemWidget('First Name', user.fName),
            ItemWidget('Last Name', user.lName),
            ItemWidget('City', user.city),
            ItemWidget('Country', user.country),
          ],
        ),
      ),
    );
  }
}
