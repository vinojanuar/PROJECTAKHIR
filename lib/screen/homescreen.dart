import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projectakhir/Gmaps/maps_page.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/api/profile_service.dart';
import 'package:projectakhir/model/historyabsen_model.dart';
import 'package:projectakhir/model/profile_model.dart';
import 'package:projectakhir/screen/checkin_screen.dart';
import 'package:projectakhir/screen/profilscreen.dart';
import 'package:projectakhir/screen/riwayatkehadiranscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String checkInTime = "-- : -- : --";
  String checkOutTime = "-- : -- : --";
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  String _currentAddress = "Belum Diketahui";
  late String _currentDate;
  late String _currentTime;
  late Timer _timer;
  late Future<List<Datum>?> _futureHistoryAbsen;
  late Future<Profile?> _futureProfile; // Tambah Future Profile

  @override
  void initState() {
    super.initState();

    _currentDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now());
    _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(now);
        _currentDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(now);
      });
    });

    _loadTodayAttendance();
    _futureHistoryAbsen = AbsenApiService.fetchHistoryAbsen();
    _futureProfile = ProfileApiService.fetchProfile();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks.first;
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}";
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error Lokasi: $e")));
    }
  }

  void _navigateToCheckIn() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckinScreen()),
    );

    if (result != null) {
      setState(() {
        checkInTime = result;
      });
    }
  }

  void _showCheckOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi Check Out",
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          "Apakah Anda yakin ingin Check Out sekarang?",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performCheckOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Ubah warna tombol
              foregroundColor: Colors.white, // Ubah warna teks tombol
            ),
            child: const Text("Check Out"),
          ),
        ],
      ),
    );
  }

  Future<void> _performCheckOut() async {
    await _ambilLokasiDanAlamat();
    final now = DateTime.now();
    final tanggal = DateFormat('yyyy-MM-dd').format(now);
    final jam = DateFormat('HH:mm').format(now);

    bool isSuccess = await AbsenApiService.checkOut(
      attendanceDate: tanggal,
      checkOutTime: jam,
      checkOutLat: _currentPosition.latitude,
      checkOutLng: _currentPosition.longitude,
      checkOutAddress: _currentAddress,
    );

    if (isSuccess) {
      setState(() {
        checkOutTime = jam;
        _futureHistoryAbsen = AbsenApiService.fetchHistoryAbsen();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check Out Berhasil")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check Out Gagal")));
    }
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final history = await AbsenApiService.fetchHistoryAbsen();
      final today = DateTime.now();

      final todayAttendance = history?.firstWhere(
        (absen) =>
            absen.attendanceDate?.year == today.year &&
            absen.attendanceDate?.month == today.month &&
            absen.attendanceDate?.day == today.day,
        orElse: () => Datum(),
      );

      setState(() {
        checkInTime = todayAttendance?.checkInTime ?? "-- : -- : --";
        checkOutTime = todayAttendance?.checkOutTime ?? "-- : -- : --";
      });
    } catch (e) {
      print("Error ambil absen hari ini: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ), // Tambah judul
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black, // Kartu utama hitam
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  FutureBuilder<Profile?>(
                    future: _futureProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: const [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white, // Avatar putih
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                              ), // Ikon hitam
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Memuat...",
                              style: TextStyle(color: Colors.white),
                            ), // Teks putih
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Row(
                          children: const [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.black),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Gagal memuat profil",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      } else {
                        final profile = snapshot.data!;
                        return Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.black),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Semangat Pagi",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white, // Teks putih
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.data?.name ?? "-",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ), // Teks putih keabuan
                                ),
                                Text(
                                  profile.data?.email ?? "-",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ), // Teks putih keabuan
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, // Bagian waktu putih
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$_currentDate • $_currentTime",
                          style: const TextStyle(
                            color: Colors.black, // Teks hitam
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors
                                .black87, // Bagian check in/out hitam keabuan
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Check In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white, // Teks putih
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    checkInTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white, // Teks putih
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 70,
                                color: Colors.white, // Pemisah putih
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Check Out",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white, // Teks putih
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    checkOutTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white, // Teks putih
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background putih
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black26,
                      ), // Border abu-abu muda
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "Jarak dari lokasi",
                              style: TextStyle(color: Colors.black54),
                            ), // Teks abu-abu
                            SizedBox(height: 4),
                            Text(
                              "250.43m", // Nilai ini mungkin perlu diperbarui secara dinamis
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Colors.black, // Teks hitam
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Tombol hitam
                            foregroundColor: Colors.white, // Teks tombol putih
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapsPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Buka Peta",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background putih
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black26,
                      ), // Border abu-abu muda
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Riwayat Absen",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black, // Teks hitam
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HistoryAbsenScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Lihat Semua",
                                style: TextStyle(color: Colors.black),
                              ), // Teks hitam
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder<List<Datum>?>(
                          future: _futureHistoryAbsen,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ), // Indikator hitam
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${snapshot.error}",
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Tidak ada riwayat absen",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              );
                            } else {
                              final history = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: history.length > 3
                                    ? 3
                                    : history.length,
                                itemBuilder: (context, index) {
                                  final absen = history[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .grey[50], // Background item riwayat abu-abu sangat muda
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors
                                            .black12, // Border sangat tipis
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _getDayName(absen.attendanceDate),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.black, // Teks hitam
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              absen.attendanceDate != null
                                                  ? "${absen.attendanceDate!.day.toString().padLeft(2, '0')}-${absen.attendanceDate!.month.toString().padLeft(2, '0')}-${absen.attendanceDate!.year}"
                                                  : '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .black87, // Teks hitam keabuan
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),

                                        absen.status?.toLowerCase() == 'izin'
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Status: Izin",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange, // Tetap gunakan orange untuk status Izin
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Alasan: ${absen.alasanIzin ?? '-'}",
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Check In",
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      ), // Teks abu-abu
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        absen.checkInTime ??
                                                            '-',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .black, // Teks hitam
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 24),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Check Out",
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      ), // Teks abu-abu
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        absen.checkOutTime ??
                                                            '-',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .black, // Teks hitam
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black, // Floating action button hitam
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Pilih Aksi",
                style: TextStyle(color: Colors.black),
              ),
              content: const Text(
                "Silakan pilih aksi yang ingin dilakukan:",
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToCheckIn();
                  },
                  child: const Text(
                    "Check In",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCheckOutDialog();
                  },
                  child: const Text(
                    "Check Out",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
        child: Image.asset(
          'assets/images/presence.png',
          width: 32,
          height: 32,
          color: Colors.white,
        ), // Ubah warna ikon jika perlu
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // BottomAppBar hitam
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/images/home.png',
                width: 24,
                height: 24,
                color: Colors.white, // Ikon putih
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: Image.asset(
                'assets/images/user.png',
                width: 24,
                height: 24,
                color: Colors.white, // Ikon putih
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime? date) {
    if (date == null) return '-';
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    return days[date.weekday % 7];
  }
}
