import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Tetap import untuk placeholder CameraPosition
// Anda akan membutuhkan geolocator & geocoding jika ingin fungsionalitas penuh
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

class KehadiranPage extends StatefulWidget {
  const KehadiranPage({super.key});

  @override
  State<KehadiranPage> createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  // Dummy data untuk contoh UI
  String _statusCheckIn = "Belum Check In";
  String _currentAddress =
      "Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatera Utara";
  LatLng _dummyMapCenter = const LatLng(
    3.5952,
    98.6773,
  ); // Koordinat Medan untuk placeholder

  // State untuk tombol "Ambil Foto"
  bool _ambilFotoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          "Kehadiran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Peta
            Container(
              height: 250, // Tinggi peta
              width: double.infinity,
              color: Colors.grey[200], // Placeholder warna abu-abu
              child: Stack(
                children: [
                  // Placeholder untuk GoogleMap
                  // Ketika diintegrasikan dengan Maps_flutter, ganti ini:
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _dummyMapCenter,
                      zoom: 14,
                    ),
                    // Hanya untuk placeholder, pastikan API key dll sudah terpasang
                    // Jika belum, ini bisa error. Untuk UI awal bisa gunakan Container kosong
                    // atau Image.asset('assets/map_placeholder.png')
                  ),
                  // Icon lokasi di tengah peta (mirip pin biru)
                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue.shade800,
                      size: 40,
                    ),
                  ),
                  // Tombol float kanan bawah (current location icon)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        // TODO: Implementasi untuk memusatkan peta ke lokasi saat ini
                        print("Tombol lokasi ditekan");
                      },
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Check In
                  Row(
                    children: [
                      const Text(
                        "Status:",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _statusCheckIn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Warna sesuai gambar
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Alamat
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alamat:",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Card Waktu Kehadiran
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Waktu Kehadiran",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 20, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Hari & Tanggal
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Monday", // Ganti dengan tanggal dinamis
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    "13-Jun-25", // Ganti dengan tanggal dinamis
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Check In
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Check In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "07 : 50 : 00", // Ganti dengan waktu dinamis
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Check Out
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Check Out",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "-", // Ganti dengan waktu dinamis atau '-'
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Ambil Foto
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100, // Background biru muda
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Ambil Foto",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8, // Menyesuaikan ukuran switch
                          child: Switch(
                            value: _ambilFotoEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _ambilFotoEnabled = value;
                              });
                            },
                            activeColor:
                                Colors.blue.shade900, // Warna ketika aktif
                            inactiveTrackColor: Colors
                                .grey[300], // Warna track ketika non-aktif
                          ),
                        ),
                        const SizedBox(width: 8), // Sedikit ruang di kanan
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Check In
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementasi logika Check In
                      print("Tombol Check In ditekan");
                      if (_ambilFotoEnabled) {
                        print("Ambil Foto diaktifkan");
                      }
                      // Misalnya, update status:
                      setState(() {
                        _statusCheckIn = "Sudah Check In";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900, // Warna biru tua
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ), // Lebar penuh, tinggi
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Check In"),
                  ),
                  const SizedBox(height: 20), // Padding di bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
