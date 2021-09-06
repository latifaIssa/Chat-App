import 'package:chat_app/Auth/models/user_model.dart';
import 'package:flutter/material.dart';

class UserPhoto extends StatelessWidget {
  Function function;
  UserModel user;
  UserPhoto(this.user, [this.function]);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                ),
                image: DecorationImage(
                  image: user.imageUrl == null
                      ? AssetImage('assets/images/defaultProfileImage.png')
                      : NetworkImage(user.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            child: Text(
              user.fName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
