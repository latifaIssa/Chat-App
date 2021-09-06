import 'package:chat_app/chat/widgets/user_photo.dart';
import 'package:chat_app/providers/user_provider.dart';
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
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                          '${provider.users[index].fName} ${provider.users[index].lName}'),
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: provider.user.imageUrl == null
                                ? AssetImage(
                                    'assets/images/defaultProfileImage.png')
                                : NetworkImage(
                                    provider.users[index].imageUrl,
                                  ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      );
    });
  }
}
