import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nama;
  final String email;
  final bool isVip;
  final String role;
  final String profession;
  final String bio;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.isVip,
    required this.role,
    required this.profession,
    required this.bio,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      isVip: data['isVip'] ?? false,
      role: data['role'] ?? 'member',
      profession: data['profession'] ?? 'Trader',
      bio: data['bio'] ?? 'Member SP Academy',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'isVip': isVip,
      'role': role,
      'profession': profession,
      'bio': bio,
    };
  }
}
