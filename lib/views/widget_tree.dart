import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/home_page.dart';
import 'package:flutter_application_2/views/pages/modul_video/modul_page.dart';
import 'package:flutter_application_2/views/pages/profile/profil_page.dart';
import 'package:flutter_application_2/views/pages/reseaech/research_page.dart';

import 'widgets/navbar_widget.dart';

class WidgetTree extends StatelessWidget {
  WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomePage(), ModulPage(), ResearchPage()];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SP ACADEMY',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.person_3),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, selectedPage, child) {
            return IndexedStack(index: selectedPage, children: pages);
          },
        ),
        bottomNavigationBar: const NavbarWidget(),
      ),
    );
  }
}
