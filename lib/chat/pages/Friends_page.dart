import 'package:chat_app/chat/pages/chat_page.dart';
import 'package:chat_app/chat/widgets/Circular__image_widget.dart';
import 'package:chat_app/chat/widgets/user_photo.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, x) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: provider.users.length,
                itemBuilder: (context, index) {
                  return UserPhoto(provider.users[index]);
                  // return Text('data');
                }),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Text(
                'Friends(${provider.users.length})',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: provider.users.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black12),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        provider.getRoomId(provider.users[index]);
                        RouteHelper.routeHelper.goToPage(ChatPage.routeName);
                      },
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                          '${provider.users[index].fName} ${provider.users[index].lName}'),
                      leading:
                          CircularImageWidget(provider.users[index].imageUrl),
                    ),
                  );
                }),
          ),
        ],
      );
    });
  }
}
