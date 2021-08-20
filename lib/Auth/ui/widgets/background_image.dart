import 'package:flutter/cupertino.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.4,
      decoration: const BoxDecoration(
        // gradient: const LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment
        //       .bottomCenter, // 10% of the width, so there are ten blinds.
        //   colors: const <Color>[
        //     Color(0xff4d47fe),
        //     Color(0xff5db5ff)
        //   ], // red to yellow
        //   tileMode: TileMode.repeated, // repeats the gradient over the canvas
        // ),
        image: DecorationImage(
          image: AssetImage('assets/images/backgroundImage.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
