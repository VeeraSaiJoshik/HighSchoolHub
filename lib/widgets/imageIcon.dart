import 'package:flutter/material.dart';

class imIcon extends StatelessWidget {
  String image;
  Color color;
  imIcon(this.image, this.color);
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color, BlendMode.colorBurn
      ),
      child: Image.asset(
        "assets/images/imageIcon/" + image + ".png",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}