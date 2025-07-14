import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/model/checkin_model.dart';
import 'package:projectakhir/screen/izin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final String _statusCheckIn = "Belum Check In";
  String _currentAddress = "Belum Diketahui";
  LatLng _currentPosition = const LatLng(-6.2, 106.8);
  late GoogleMapController _mapController;
  int? _userId;

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> _ambilLokasiDanAlamat() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw "GPS tidak aktif!";

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw "Izin lokasi ditolak.";
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks.first;
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error Lokasi: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    _ambilLokasiDanAlamat();
  }

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('EEEE', 'id_ID').format(DateTime.now());
    final String dateNow = DateFormat('dd-MMM-yy').format(DateTime.now());
    final String jamNow = DateFormat('HH:mm:ss').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        title: const Text(
          "Kehadiran",
          style: TextStyle(color: Colors.white),
        ), // Teks putih
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Ikon putih
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 16,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: _currentPosition,
                      ),
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor:
                          Colors.black, // Floating action button hitam
                      onPressed: _ambilLokasiDanAlamat,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ), // Ikon putih
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
                  Row(
                    children: [
                      const Text(
                        "Status:",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ), // Teks hitam keabuan
                      const SizedBox(width: 8),
                      Text(
                        _statusCheckIn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Tetap orange untuk status
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alamat:",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ), // Teks hitam
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background putih
                      border: Border.all(color: Colors.black), // Border hitam
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              today,
                              style: const TextStyle(color: Colors.black87),
                            ), // Teks abu-abu
                            const SizedBox(height: 4),
                            Text(
                              dateNow,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Colors.black, // Teks hitam
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Jam",
                              style: TextStyle(color: Colors.black87),
                            ), // Teks abu-abu
                            const SizedBox(height: 4),
                            Text(
                              jamNow,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Colors.black, // Teks hitam
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _ambilLokasiDanAlamat();
                            final checkinTime = DateFormat(
                              'HH:mm',
                            ).format(DateTime.now());
                            final checkinDate = DateFormat(
                              'yyyy-MM-dd',
                            ).format(DateTime.now());

                            final CheckIn? response =
                                await AbsenApiService.checkIn(
                                  attendanceDate: checkinDate,
                                  checkInTime: checkinTime,
                                  checkInLat: _currentPosition.latitude,
                                  checkInLng: _currentPosition.longitude,
                                  checkInAddress: _currentAddress,
                                  status: "masuk",
                                );

                            if (response != null &&
                                response.message == "Absen masuk berhasil") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Check In Berhasil"),
                                ),
                              );
                              Navigator.pop(context, checkinTime);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    response?.message ?? "Check In Gagal",
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Tombol hitam
                            foregroundColor: Colors.white, // Teks tombol putih
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Check In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IzinScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Tombol putih
                            foregroundColor: Colors.black, // Teks tombol hitam
                            side: const BorderSide(
                              color: Colors.black,
                            ), // Border hitam
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Izin",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
