import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  CustomTextWidget(
      {super.key,
      this.color,
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 20,
      this.height = 1,  this.fontWeight,});

  CustomTextWidget.smallText(
      {super.key,
      this.color,
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 12,
      this.height = 1.2,  this.fontWeight});

  Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  double height;
  final   FontWeight?fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontSize: size,
          fontWeight: fontWeight??FontWeight.w400,
          fontFamily: 'Manrope',
          height: height),
    );
  }
}
