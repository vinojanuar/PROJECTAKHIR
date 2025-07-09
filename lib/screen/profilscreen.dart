import 'package:flutter/material.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/screen/loginscreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 12),
            const Text(
              "Muhammad Rio Akbar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text("123456789"),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Ubah Profil"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Ubah Kata Sandi"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await PreferenceHandler.logout(); // Hapus token & status login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginscreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
