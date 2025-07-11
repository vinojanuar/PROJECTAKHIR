import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projectakhir/Gmaps/maps_page.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/model/historyabsen_model.dart';
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

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance(); // Otomatis ambil dari API saat buka Home
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
        title: const Text("Konfirmasi Check Out"),
        content: const Text("Apakah Anda yakin ingin Check Out sekarang?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performCheckOut();
            },
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Semangat Pagi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text("Muhammad Rio Akbar"),
                          Text("123456789"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xff84BFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Jl. Pangeran Diponegoro No. 5, Kec. Medan Petisah, Kota Medan, Sumatera Utara",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 119, 165, 243),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    checkInTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 70,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Check Out",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    checkOutTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white,
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
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("Distance from place"),
                            SizedBox(height: 4),
                            Text(
                              "250.43m",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
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
                            "Open Maps",
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "History Absen",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                              child: const Text("Lihat Semua"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder<List<Datum>?>(
                          future: AbsenApiService.fetchHistoryAbsen(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text("Tidak ada history absen"),
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
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
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              absen.attendanceDate != null
                                                  ? "${absen.attendanceDate!.day.toString().padLeft(2, '0')}-${absen.attendanceDate!.month.toString().padLeft(2, '0')}-${absen.attendanceDate!.year}"
                                                  : '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text("Check In"),
                                                const SizedBox(height: 4),
                                                Text(
                                                  absen.checkInTime ?? '-',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 24),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text("Check Out"),
                                                const SizedBox(height: 4),
                                                Text(
                                                  absen.checkOutTime ?? '-',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
        backgroundColor: Colors.blue[300],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Pilih Aksi"),
              content: const Text("Silakan pilih aksi yang ingin dilakukan:"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToCheckIn();
                  },
                  child: const Text("Check In"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCheckOutDialog();
                  },
                  child: const Text("Check Out"),
                ),
              ],
            ),
          );
        },
        child: Image.asset('assets/images/presence.png', width: 32, height: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
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
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: Image.asset(
                'assets/images/user.png',
                width: 24,
                height: 24,
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
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return days[date.weekday % 7];
  }
}
