import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/widgets/benner_widget.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Hero1',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 3)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: BennerWidget(),
        ),
      ),
    );
  }
}
