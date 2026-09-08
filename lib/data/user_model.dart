import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nama;
  final String email;
  final bool isVip;
  final String profession;
  final String bio;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.isVip,
    required this.profession,
    required this.bio,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      isVip: data['isVip'] ?? false,
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
      'profession': profession,
      'bio': bio,
    };
  }
}
