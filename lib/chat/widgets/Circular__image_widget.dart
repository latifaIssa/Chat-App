import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  String url;
  CircularImageWidget(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        color: Colors.blueGrey,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: url == null
              ? AssetImage('assets/images/defaultProfileImage.png')
              : NetworkImage(
                  url,
                ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
