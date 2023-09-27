import 'package:flutter/material.dart';

class ResultNotice extends StatelessWidget {
  final Color color;
  final String info;
  final AnimationController controller;

  const ResultNotice({
    Key? key,
    required this.color,
    required this.info,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      color: color,
      // child: Text(
      //   info,
      //   style: const TextStyle(
      //       fontSize: 54, color: Colors.white, fontWeight: FontWeight.bold),
      // ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) => Text(
          info,
          style: TextStyle(
              fontSize: 54 * (controller.value),
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
