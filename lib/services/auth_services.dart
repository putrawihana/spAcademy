import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/user_model.dart';

ValueNotifier<AuthServices> authService = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<String?> register({
    required String email,
    required String password,
    required String nama,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nama': nama,
        'email': email,
        'isVip': false,
        'role': 'member',
        'profession': 'Trader',
        'bio': 'Member Baru SP Academy',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email ini sudah terdaftar.Silahkan login dengan email lain.';
      } else if (e.code == 'weak-password') {
        return 'Password terlalu lemah (minimal 6 karakter).';
      }
      return e.message ?? 'Terjadi kesalahan saat pendaftaran.';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return 'Email atau password salah.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      }
      return e.message ?? 'Gagal masuk. Periksa koneksi Anda.';
    } catch (e) {
      return 'Terjadi kesalahan sistme.';
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Stream<UserModel?> getUserDataStream() {
    String? uid = currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromFirestore(snapshot);
    });
  }

  Future<UserModel?> getUserDataOnce() async {
    String? uid = currentUser?.uid;
    if (uid == null) return null;

    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<String?> updateProfile({
    required String nama,
    required String profession,
    required String bio,
  }) async {
    try {
      String? uid = currentUser?.uid;
      if (uid == null) {
        return 'Pengguna belum masuk (login).';
      }
      await _firestore.collection('users').doc(uid).update({
        'nama': nama,
        'profession': profession,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await currentUser?.updateDisplayName(nama);
      return null;
    } on FirebaseException catch (e) {
      return e.message ?? 'Gagal menyimpan perubahan ke database.';
    } catch (e) {
      return 'Terjadi kesalan sistem.';
    }
  }

  Future<void> upgradeToVip() async {
    String? uid = currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({'isVip': true});
    }
  }

  Future<String?> uploadResearch({
    required String judul,
    required String ticker,
    required String emiten,
    required String descripsi,
    required bool isVipOnly,
    String? imageUrl,
    String? takeProfit,
    String? entryPoint,
    String? stopLoss,
  }) async {
    try {
      await _firestore.collection('researches').add({
        'judul': judul,
        'ticker': ticker.toUpperCase(),
        'emiten': emiten,
        'descripsi': descripsi,
        'imageUrl': imageUrl ?? '',
        'takeProfit': takeProfit ?? '',
        'entryPoint': entryPoint ?? '',
        'stopLoss': stopLoss ?? '',
        'isVipOnly': isVipOnly,
        'tanggal': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> uploadModul({
    required String judul,
    required String level,
    required String videoUrl,
    required bool isVipOnly,
  }) async {
    try {
      await _firestore.collection('modules').add({
        'judul': judul,
        'level': level,
        'videoUrl': videoUrl.trim(),
        'isVipOnly': isVipOnly,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<UserModel>> getAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> setUserVipStatus(String uid, bool isVip) async {
    await _firestore.collection('users').doc(uid).update({'isVip': isVip});
  }

  Stream<QuerySnapshot> getResearchesStream() {
    return _firestore
        .collection('researches')
        .orderBy('tanggal', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getModulesStream({String? level}) {
    Query query = _firestore
        .collection('modules')
        .orderBy('createdAt', descending: true);
    if (level != null && level.isNotEmpty) {
      query = query.where('level', isEqualTo: level);
    }
    return query.snapshots();
  }

  Future<void> updateModuleCompletion(String docId, bool isComplated) async {
    try {
      await _firestore.collection('modules').doc(docId).update({
        'isCompleted': isComplated,
      });
    } catch (e) {
      print('Gagal memperbarui status modul $e');
    }
  }

  Future<void> deleteModule(String docId) async {
    await _firestore.collection('modules').doc(docId).delete();
  }
}
