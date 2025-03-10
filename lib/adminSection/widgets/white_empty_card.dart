import 'package:flutter/cupertino.dart';

class WhiteEmptyCard extends StatelessWidget {
  const WhiteEmptyCard(
      {super.key,
      required this.child,
      this.height,
      this.width,
      this.margin,
      this.color,
      this.border, this.padding});

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding?? EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color ?? Color(0xffffffff),
          borderRadius: BorderRadius.circular(30),
          border: border),
      child: child,
    );
  }
}
