import 'package:flutter/material.dart';

/// Widget ini menampilkan ikon C Copyright dan teks Copyright di bagian bawah layar.
/// Dapat digunakan di berbagai screen aplikasi untuk konsistensi tampilan.
class CopyrightFooter extends StatelessWidget {
  /// Konstruktor widget copyright (tidak menerima parameter khusus).
  const CopyrightFooter({super.key});

  /// Fungsi build membangun tampilan widget copyright.
  /// Menggunakan Row agar ikon dan teks sejajar di tengah.
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Memberi jarak atas dan bawah agar tidak terlalu menempel dengan konten lain
      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Posisikan di tengah
        children: const [
          // Ikon C Copyright
          Icon(Icons.copyright, size: 20, color: Colors.grey),
          SizedBox(width: 8), // Jarak antara ikon dan teks
          // Teks copyright
          Text(
            "Copyright",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
