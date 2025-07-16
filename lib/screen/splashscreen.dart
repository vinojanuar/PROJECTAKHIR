import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/screen/homescreen.dart';
import 'package:projectakhir/screen/loginscreen.dart';
import 'package:projectakhir/widget/copyright_footer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fungsi yang dijalankan saat SplashScreen dimulai, untuk navigasi otomatis setelah delay.
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      navigateUser();
    });
  }

  // Fungsi untuk menentukan navigasi user ke HomeScreen atau LoginScreen berdasarkan token.
  Future<void> navigateUser() async {
    String? token = await PreferenceHandler.getToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
      );
    }
  }

  // Widget utama SplashScreen yang menampilkan logo dan nama aplikasi.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/presentime_logo.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            // Text
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: 'Montserrat',
                ),
                children: [
                  TextSpan(
                    text: 'Presen',
                    style: TextStyle(color: Color(0xFF1E293B)),
                  ),
                  TextSpan(
                    text: 'Time',
                    style: TextStyle(color: Color(0xFF7C3AED)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }
}
