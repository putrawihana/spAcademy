import 'package:flutter/material.dart';

class ContainerBenner extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const ContainerBenner({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.3),
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: child,
    );
  }
}
