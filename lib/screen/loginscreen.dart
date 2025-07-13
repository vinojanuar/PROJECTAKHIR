import 'package:flutter/material.dart';
import 'package:projectakhir/api/user_api.dart';
import 'package:projectakhir/screen/homescreen.dart';
import 'package:projectakhir/screen/registerscreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService =
      UserService(); // Pastikan ini sudah diimplementasikan dengan benar

  bool isLoading = false;
  bool _obscureText = true;

  void login() async {
    setState(() {
      isLoading = true;
    });

    // Simulasi API call
    final res = await userService.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (res["errors"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maaf, ${res["message"]}"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Hitam
          Container(
            color: Colors.black, // Latar belakang hitam pekat
            height: 250,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Text(
              "Presence App",
              style: TextStyle(
                color: Colors.white, // Teks putih
                fontSize: 28, // Ukuran font lebih besar
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 24, // Ukuran judul lebih besar
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Teks hitam
                    ),
                  ),
                  const SizedBox(height: 32), // Spasi lebih besar
                  TextField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Colors.black,
                    ), // Warna teks input
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                      ), // Warna label
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ), // Border saat aktif
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ), // Border lebih bulat
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1,
                        ), // Border saat tidak aktif
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ), // Padding dalam input
                    ),
                  ),
                  const SizedBox(height: 20), // Spasi antar input
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    style: const TextStyle(
                      color: Colors.black,
                    ), // Warna teks input
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600], // Warna ikon
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32), // Spasi sebelum tombol
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Tombol hitam
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Bentuk tombol lebih kotak
                        ),
                        elevation: 0, // Tanpa shadow
                      ),
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white, // Indikator loading putih
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Log in",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white, // Teks tombol putih
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implementasi lupa kata sandi
                      },
                      child: const Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Warna teks abu-abu
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum punya akun?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Teks hitam
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Regisscreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black, // Teks "Register" hitam
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
