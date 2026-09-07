import 'dart:async';
import 'package:flutter/material.dart';

class TypingTextPage extends StatefulWidget {
  const TypingTextPage({super.key});

  @override
  State<TypingTextPage> createState() => _TypingTextPageState();
}

class _TypingTextPageState extends State<TypingTextPage> {
  // Teks lengkap yang ingin ditampilkan
  final String fullText =
      "I want one ticket out of your heavy gaze\n"
      "I want one ticket off your carousel\n"
      "but you should know that I die slow.";

  // Teks yang akan tampil di layar (mulai dari kosong)
  String displayedText = "";
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTypingEffect();
  }

  void startTypingEffect() {
    // Timer akan berjalan tiap beberapa milidetik untuk menambah 1 huruf
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (currentIndex < fullText.length) {
        setState(() {
          currentIndex++;
          displayedText = fullText.substring(0, currentIndex);
        });
      } else {
        _timer?.cancel(); // Berhenti kalau teks sudah habis
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Jangan lupa matikan timer saat halaman ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            displayedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'monospace', // Agar mirip teks terminal/kode
            ),
          ),
        ),
      ),
    );
  }
}
