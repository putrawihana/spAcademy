import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/user_model.dart';

ValueNotifier<AuthServices> authService = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth
      .instance; //mempermudah ketika mau pakai instance cukup firebaseAuth aja
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges =>
      firebaseAuth.authStateChanges(); //mendengarkan perubahaan real time

  Future<String?> register({
    required String email,
    required String password,
    required String nama,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
      //usercredential untuk menyimpan data yang penting dan ini wadah yang lebih
      //kemudian masuk ke user agar bisa mendapatkan uid
      // perlu uid karena keta mau membuat data baru sedang kan login hanya memangil uid yang sudah ada

      await _firestore.collection('users').doc(uid).set({
        //pakai uid agar data ini milik satu user
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
      //mengubah kode error dari firebase
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
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists && (doc.data()?['isDeleted'] == true)) {
        await firebaseAuth.signOut();
        return 'akun ini sudah di block!!';
      }
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
    //hanya membuat akun tidak nambah data yang lain nya, tapi ada uid
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
    // fungsi ini harus pakai domain resmi agar link reset
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    //tidak di pakai tapi bisa jadi contoh ini cuma update nama
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    if (currentUser == null) {
      throw Exception('Tidak ada sesi pengguna yang Aktif');
    }
    final uid = currentUser!.uid;
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(uid).delete();
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> deletedAccountSave({
    //cuma hilangin akses login
    //tambah cap isDeleted biar ngk bisa login, di login page di cek
    required String email,
    required String password,
  }) async {
    if (currentUser == null) throw Exception('Tidak ada user Yang login');
    final uid = currentUser!.uid;
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(uid).update({
      'isDeleted': true,
      'atDeleted': FieldValue.serverTimestamp(),
    });
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    //baris ini akan menjadi email dan pasword lama jadi tiket
    //kalo tiket cocok maka updated password baru jalan
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Stream<UserModel?> getUserDataStream() {
    String? uid = currentUser?.uid;
    if (uid == null)
      return Stream.value(
        null,
      ); //ini kan Stream jadi value yang di ubah ikut streamnya
    //steama harus pakai snapshot karena dia yang mendengarkan perubahan
    //pakai map untuk menerjemahkan objek mentah
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromFirestore(snapshot);
    });
  }

  Future<UserModel?> getUserDataOnce() async {
    //mengambil sekali saja, jadi harus di panggil lagi untuk mendapat pembaruan
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
      return null;
    } on FirebaseException catch (e) {
      return e.message ?? 'Gagal menyimpan perubahan ke database.';
    } catch (e) {
      return 'Terjadi kesalan sistem.';
    }
  }

  //upgrade vip dengan membalikan nilai isVip
  Future<void> setUserVipStatus(String uid, bool isVip) async {
    await _firestore.collection('users').doc(uid).update({'isVip': isVip});
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

  Stream<QuerySnapshot> getResearchesStream() {
    //mengurutkan berdasar kan tanggal
    return _firestore
        .collection('researches')
        .orderBy(
          'tanggal',
          descending: true,
        ) //descending dari yang paling besar
        .snapshots();
  }

  Future<void> deleteResearche(String docId) async {
    //perlu docId agar bisa hapus berdasarkan id nya
    await _firestore.collection('researches').doc(docId).delete();
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
        'videoUrl': videoUrl
            .trim(), //pakai trim kerena biasa kalo paste ada space
        'isVipOnly': isVipOnly,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<UserModel>> getAllUsersStream() {
    //map yang pertama untuk menangkap perubahan, yang kedua untuk mengubah data mentah dari list
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  Stream<QuerySnapshot> getModulesStream({String? level}) {
    // Query itu daftar pesanan atau instruksi penyaringan
    Query query = _firestore
        .collection('modules')
        .orderBy('createdAt', descending: true);
    if (level != null && level.isNotEmpty) {
      //ini sebenarnya null atau tidak bekerja karena level pasti null (tidak di panggil)
      //cari dokumen di modul yang nilainay sama dengan level
      query = query.where(
        'level',
        isEqualTo: level,
      ); //isEqualto menapil kan apa yangsesuai
    }
    return query.snapshots();
  }

  Future<void> updateModuleCompletion(String moduleId, bool isCompleted) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    if (isCompleted) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('completedModules')
          .doc(moduleId)
          .set({'completedAt': FieldValue.serverTimestamp()});
    } else {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('completedModules')
          .doc(moduleId)
          .delete();
    }
  }

  Stream<List<String>> getCompletedModulesStream() {
    final uid = currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('completedModules')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
    //map pertama terjemah yang kedua agar masuk ke dalam satu satu
  }

  Future<void> deleteModule(String docId) async {
    await _firestore.collection('modules').doc(docId).delete();
  }

  //<<<<<<<<<<<<<<<<<<<<<<   watchlist   >>>>>>>>>>>>>>>>>>>>>>//
  Future<List<Map<String, String>>> getStockList() async {
    //mengambil semua data sekali
    final snapshot = await _firestore
        .collection('stockList')
        .orderBy('symbol')
        .get();
    return snapshot //snapshot hanya tempat nampung sementara hasil dari get
        .docs
        .map(
          (doc) => {
            'symbol': doc.data()['symbol'] as String,
            'name': doc.data()['name'] as String,
          },
        )
        .toList();
  }

  // ini baru pantau apa yang di masukin ke watchlist
  Stream<List<Map<String, String>>> getWatchlistStream() {
    final uid = currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        .orderBy('addedAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'symbol': doc.data()['symbol'] as String,
                  'name': doc.data()['name'] as String? ?? '',
                },
              )
              .toList(),
        );
  }

  Future<void> addToWatchlist(String symbol, String name) async {
    //mengirim ke watchlist
    final uid = currentUser?.uid;
    if (uid == null) return;
    final existing =
        await _firestore //cek dulu apakah sudah ada di watchlist
            .collection('users')
            .doc(uid)
            .collection('watchlist')
            .where('symbol', isEqualTo: symbol)
            .get();
    if (existing.docs.isNotEmpty) return;

    await _firestore.collection('users').doc(uid).collection('watchlist').add({
      'symbol': symbol,
      'name': name,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromWatchlist(String symbol) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    final hasiQuery =
        await _firestore //user berdasarkan uid -> watchlist -> symbol
            .collection('users')
            .doc(uid)
            .collection('watchlist')
            .where(
              'symbol',
              isEqualTo: symbol,
            ) //apa yang mau di ambil pakai query
            .get(); //ini baru perintah untuk amabil . jadi ini query
    for (final doc in hasiQuery.docs) {
      await doc.reference.delete();
    }
  }
}
