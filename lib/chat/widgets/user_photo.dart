import 'package:chat_app/Auth/models/user_model.dart';
import 'package:chat_app/chat/widgets/Circular__image_widget.dart';
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
            child: CircularImageWidget(user.imageUrl),
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
