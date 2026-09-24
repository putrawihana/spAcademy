import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //menayalakan mesin flutter biasanay di gunakana kalo pakai plugin
  //biasanya ini ngk perlu di tulis eksplisit karena udh di tulis flutter
  //tapi karena di sini async harus di tulis

  //ini sebagai penghubung ke firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null); //format tanggal
  runApp(const MyApp());
}

class NonStreach extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initsThemeMode();
    super.initState();
  }

  void initsThemeMode() async {
    //menyimpan defuld tampilan ke hp jadi tiap user beda
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(KConstans.themeModeKey);
    isDarkNotifier.value = repeat ?? false;
  }

  //kenapa ngk langsung runApp(MeterialApp) sebenarnaya bisa aja tapi kalo membuat  logic
  //kita harus buat pembungkus untuk menarapkan logicnya
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          //widget flutter untuk menyiapkan semuanaya
          initialRoute: '/',
          routes: {
            '/welcome': (context) => WelcomePage(),
          }, //kamus untuk navigator
          scrollBehavior: NonStreach(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF020617),
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          title: 'spAcademy',
          home: WelcomePage(),
        );
      },
    );
  }
}
