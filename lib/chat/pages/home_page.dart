import 'package:chat_app/Auth/providers/auth_provider.dart';
import 'package:chat_app/chat/pages/Friends_page.dart';
import 'package:chat_app/chat/pages/profile_page.dart';
import 'package:chat_app/chat/widgets/action_bar_button.dart';
import 'package:chat_app/chat/widgets/user_photo.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserFromFirebase();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Consumer<UserProvider>(builder: (context, provider, x) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          toolbarHeight: height * 0.1,
          actions: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[50],
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  RouteHelper.routeHelper.goToPage(ProfilePage.routeName);
                },
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          image: DecorationImage(
                            image: provider.user.imageUrl == null
                                ? AssetImage(
                                    'assets/images/defaultProfileImage.png')
                                : NetworkImage(provider.user.imageUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      provider.user.fName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            ActionButton(
                Provider.of<AuthProvider>(context, listen: false).logOut,
                Icons.logout),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.blueAccent,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Friends',
                    ),
                    Tab(
                      text: 'Chat',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: provider.users.length,
                    //     itemBuilder: (context, index) {
                    //       return UserPhoto(provider.users[index]);
                    //     }),
                    FriendsList(),
                    // second tab bar view widget
                    Center(
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
