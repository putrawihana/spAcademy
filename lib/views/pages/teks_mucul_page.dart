import 'dart:async';
import 'package:flutter/material.dart';

class TypingTextPage extends StatefulWidget {
  const TypingTextPage({super.key});

  @override
  State<TypingTextPage> createState() => _TypingTextPageState();
}

class _TypingTextPageState extends State<TypingTextPage> {
  final String fullText =
      "I want one ticket out of your heavy gaze\n"
      "I want one ticket off your carousel\n"
      "but you should know that I die slow.";

  String displayedText = "";
  int currentIndex = 0;
  Timer? _timer;

  // Penanda arah: true = sedang mengetik (maju), false = sedang menghapus (mundur)
  bool isTypingForward = true;

  @override
  void initState() {
    super.initState();
    startTypingEffect();
  }

  void startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      setState(() {
        if (isTypingForward) {
          // KONDISI 1: Sedang mengetik maju
          if (currentIndex < fullText.length) {
            currentIndex++;
            displayedText = fullText.substring(0, currentIndex);
          } else {
            // Kalau sudah penuh, tunggu sebentar (atau langsung ubah arah)
            // lalu mulai proses menghapus mundur
            isTypingForward = false;
          }
        } else {
          // KONDISI 2: Sedang menghapus mundur
          if (currentIndex > 0) {
            currentIndex -= 2;
            if (currentIndex < 0) currentIndex = 0;
            displayedText = fullText.substring(0, currentIndex);
          } else {
            // Kalau sudah habis (kembali ke 0), ubah arah lagi ke depan
            isTypingForward = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
