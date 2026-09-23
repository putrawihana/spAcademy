import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/widgets/modul_widget.dart';

class ModulPage extends StatelessWidget {
  ModulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ModulWidget(benner: true));
  }
}
