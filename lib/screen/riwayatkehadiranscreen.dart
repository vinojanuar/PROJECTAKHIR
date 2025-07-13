import 'package:flutter/material.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/model/historyabsen_model.dart';

class HistoryAbsenScreen extends StatefulWidget {
  const HistoryAbsenScreen({super.key});

  @override
  State<HistoryAbsenScreen> createState() => _HistoryAbsenScreenState();
}

class _HistoryAbsenScreenState extends State<HistoryAbsenScreen> {
  late Future<List<Datum>?> _futureHistoryAbsen;

  @override
  void initState() {
    super.initState();
    _futureHistoryAbsen = AbsenApiService.fetchHistoryAbsen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Riwayat Kehadiran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[100], // Latar belakang abu-abu muda
      body: FutureBuilder<List<Datum>?>(
        future: _futureHistoryAbsen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ); // Loading indicator hitam
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi error: ${snapshot.error}",
                style: const TextStyle(color: Colors.black),
              ),
            ); // Teks error hitam
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Data tidak ditemukan",
                style: TextStyle(color: Colors.black),
              ),
            ); // Teks hitam
          } else {
            final history = snapshot.data!;
            if (history.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada data kehadiran.",
                  style: TextStyle(color: Colors.black),
                ),
              ); // Teks hitam
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final absen = history[index];
                final isIzin = absen.status?.toLowerCase() == 'izin';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      // Tambahkan shadow tipis
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hari dan Tanggal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getDayName(absen.attendanceDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            absen.attendanceDate != null
                                ? "${absen.attendanceDate!.day.toString().padLeft(2, '0')}-${absen.attendanceDate!.month.toString().padLeft(2, '0')}-${absen.attendanceDate!.year}"
                                : '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (isIzin) ...[
                        const Text(
                          "Status: Izin",
                          style: TextStyle(
                            color: Colors
                                .orange, // Tetap gunakan orange untuk izin agar menonjol
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Alasan: ${absen.alasanIzin ?? '-'}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Check In",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  absen.checkInTime ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Check Out",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  absen.checkOutTime ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  /// Fungsi untuk mendapatkan nama hari dari DateTime
  String _getDayName(DateTime? date) {
    if (date == null) return '-';
    final days = [
      'Minggu', // Sunday
      'Senin', // Monday
      'Selasa', // Tuesday
      'Rabu', // Wednesday
      'Kamis', // Thursday
      'Jumat', // Friday
      'Sabtu', // Saturday
    ];
    // DateTime.weekday returns 1 for Monday, 7 for Sunday.
    // We adjust it to match our 0-indexed list (Sunday is 0).
    return days[date.weekday % 7];
  }
}
