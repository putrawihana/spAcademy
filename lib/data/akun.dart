import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Akun {
  String email;
  String password;

  Akun(this.email, this.password);

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
  factory Akun.fromJson(Map<String, dynamic> json) =>
      Akun(json['email'], json['password']);
}

Future<void> simpanAkun(List<Akun> semuaAkun) async {
  final prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> jsonList = semuaAkun
      .map((a) => a.toJson())
      .toList();
  await prefs.setString('semuaAkun', jsonEncode(jsonList));
}

Future<List<Akun>> muatDataUser() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsontString = prefs.getString('semuaAkun');
  if (jsontString != null) {
    List<dynamic> data = jsonDecode(jsontString);
    return data.map((x) => Akun.fromJson(x)).toList();
  }
  return [];
}
