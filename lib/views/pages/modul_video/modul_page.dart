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

// ListTile(
//                                       contentPadding: const EdgeInsets.all(10),
//                                       leading: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           color: Colors.teal,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                         child: 
//                                       ),
//                                       title: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               judul,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15,
//                                                 color: isDark
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                           
//                                         ],
//                                       ),
//                                       subtitle: Column(
//                                         children: [
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             'Level: ${level.toUpperCase()} $ringkasan',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: isDark
//                                                   ? Colors.grey.shade400
//                                                   : Colors.grey.shade600,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       trailing: 
//                                       onTap: () {
//                                         
//                                       },
//                                     ),