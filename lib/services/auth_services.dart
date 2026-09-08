import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
