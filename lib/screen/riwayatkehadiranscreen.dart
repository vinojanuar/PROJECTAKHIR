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
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Datum>?>(
        future: _futureHistoryAbsen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          } else {
            final history = snapshot.data!;
            if (history.isEmpty) {
              return const Center(child: Text("Belum ada data kehadiran."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final absen = history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian Hari & Tanggal
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDayName(absen.attendanceDate),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            absen.attendanceDate != null
                                ? "${absen.attendanceDate!.day.toString().padLeft(2, '0')}-${absen.attendanceDate!.month.toString().padLeft(2, '0')}-${absen.attendanceDate!.year}"
                                : '-',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Bagian Check In & Check Out
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  /// Fungsi untuk mendapatkan nama hari dari DateTime
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
