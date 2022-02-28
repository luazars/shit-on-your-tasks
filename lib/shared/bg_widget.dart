import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget widget;
  const Background(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        width: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     colorFilter: ColorFilter.mode(
        //         Colors.white.withOpacity(0.4), BlendMode.dstATop),
        //     image: const AssetImage("assets/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: widget);
  }
}
