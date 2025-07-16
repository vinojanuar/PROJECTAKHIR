import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // Untuk geolokasi
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Untuk geocoding

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  // Deklarasi variabel yang dibutuhkan
  GoogleMapController? mapController;
  LatLng? _currentPosition; // Posisi latitude dan longitude saat ini
  String _currentAddress = "Mencari Lokasi..."; // Alamat saat ini
  Marker? _marker; // Marker untuk lokasi saat ini

  // Fungsi yang dijalankan saat inisialisasi, memanggil fungsi untuk mendapatkan lokasi.
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan lokasi saat aplikasi pertama kali dibuka
    _getCurrentLocation();
  }

  // Fungsi untuk mendapatkan lokasi saat ini, meminta izin lokasi, dan update marker serta alamat.
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika layanan lokasi tidak diaktifkan, buka pengaturan lokasi
      await Geolocator.openLocationSettings();
      return; // Keluar dari fungsi
    }

    // Periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Jika izin masih ditolak, keluar dari fungsi
        // Anda mungkin ingin menampilkan pesan kepada pengguna di sini
        return;
      }
    }

    // Dapatkan posisi saat ini
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Update _currentPosition
    _currentPosition = LatLng(position.latitude, position.longitude);

    // Dapatkan placemark (informasi alamat) dari koordinat
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    Placemark place = placemarks[0]; // Ambil placemark pertama

    // Update state dengan informasi lokasi dan marker baru
    setState(() {
      _marker = Marker(
        markerId: const MarkerId("lokasi_saya"),
        position: _currentPosition!,
        infoWindow: InfoWindow(
          title: "Lokasi Anda",
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      // Bentuk string alamat
      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

      // Animasikan kamera peta ke lokasi baru
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 16),
        ),
      );
    });
  }

  // Widget utama MapsPage yang menampilkan Google Map dan alamat saat ini.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul
      appBar: AppBar(title: const Text('Google Map + Geolocator + Geocoding')),
      body: Stack(
        children: [
          // Widget GoogleMap
          GoogleMap(
            initialCameraPosition: CameraPosition(
              // Jika _currentPosition null, gunakan posisi default (misal Jakarta)
              target: _currentPosition ?? const LatLng(-6.2088, 106.8456),
              zoom: 14, // Zoom awal
            ),
            onMapCreated: (controller) {
              mapController = controller; // Simpan controller peta
            },
            markers: _marker != null
                ? {_marker!}
                : {}, // Tampilkan marker jika ada
            myLocationEnabled: true, // Tampilkan titik lokasi saya
            myLocationButtonEnabled: true, // Tampilkan tombol lokasi saya
          ),
          // Widget untuk menampilkan alamat saat ini di pojok kanan atas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      // Tombol Floating Action untuk refresh lokasi
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip:
            "Refresh Lokasi", // Panggil fungsi _getCurrentLocation saat ditekan
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
