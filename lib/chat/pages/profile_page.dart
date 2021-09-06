import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/chat/widgets/item_widget.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = 'profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
              onPressed: () {
                // Provider.of<UserProvider>(context, listen: false)
                //     .fillControllers();
                // RouteHelper.routeHelper.goToPage(UpdateProfile.routeName);
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, x) {
          return provider.user == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      provider.user.imageUrl == null
                          ? CircleAvatar(
                              // height: 200,
                              // width: 200,
                              // backgroundColor: Colors.grey,
                              backgroundImage: AssetImage(
                                  'assets/images/defaultProfileImage.png'),
                              radius: 70,
                            )
                          : CircleAvatar(
                              // height: 200,
                              // width: 200,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                provider.user.imageUrl,
                              ),
                              radius: 70,
                            ),
                      ItemWidget('Email', provider.user.email),
                      ItemWidget('First Name', provider.user.fName),
                      ItemWidget('Last Name', provider.user.lName),
                      ItemWidget('City', provider.user.city),
                      ItemWidget('Country', provider.user.country),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
