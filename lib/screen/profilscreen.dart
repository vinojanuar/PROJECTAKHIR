import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/api/profile_service.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/model/absenstatus_model.dart';
import 'package:projectakhir/model/absentoday_model.dart';
import 'package:projectakhir/model/profile_model.dart';
import 'package:projectakhir/screen/editprofile_screen.dart';
import 'package:projectakhir/screen/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Profile?> _futureProfile;
  late Future<AbsenStatus?> _futureAbsenStatus;
  late Future<AbsenToday?> _futureAbsenToday;

  @override
  void initState() {
    super.initState();
    _futureProfile = ProfileApiService.fetchProfile();
    _futureAbsenStatus = AbsenApiService.fetchAbsenStatus();
    _futureAbsenToday = AbsenApiService.fetchAbsenToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      body: SafeArea(
        child: FutureBuilder<Profile?>(
          future: _futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Gagal memuat data profil"));
            } else {
              final profile = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Mengubah CircleAvatar menjadi hitam dengan ikon putih
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black, // Background hitam
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ), // Ikon putih
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.data?.name ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black, // Teks nama hitam
                      ),
                    ),
                    Text(
                      profile.data?.email ?? "-",
                      style: const TextStyle(
                        color: Colors.grey,
                      ), // Teks email abu-abu
                    ),
                    const SizedBox(height: 24),

                    // ====== STATISTIK ABSEN ======
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Colors.grey[100], // Background abu-abu muda
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Absen Status",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black, // Teks hitam
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<AbsenStatus?>(
                                  future: _futureAbsenStatus,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(
                                        color: Colors.black,
                                      ); // Indikator hitam
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.data == null) {
                                      return const Text(
                                        "Gagal memuat statistik absen",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ), // Teks abu-abu
                                      );
                                    } else {
                                      final data = snapshot.data!.data!;
                                      int alpha =
                                          (data.totalAbsen ?? 0) -
                                          (data.totalMasuk ?? 0) -
                                          (data.totalIzin ?? 0);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _StatCard(
                                            label: "Hadir",
                                            count: data.totalMasuk ?? 0,
                                            color: Colors.black, // Warna hitam
                                          ),
                                          _StatCard(
                                            label: "Izin",
                                            count: data.totalIzin ?? 0,
                                            color: Colors.grey, // Warna abu-abu
                                          ),
                                          _StatCard(
                                            label: "Alpha",
                                            count: alpha < 0 ? 0 : alpha,
                                            color: Colors
                                                .red, // Warna merah untuk alpha (tetap)
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Colors.grey[100], // Background abu-abu muda
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Absen Today",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black, // Teks hitam
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<AbsenToday?>(
                                  future: _futureAbsenToday,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ), // Indikator hitam
                                      );
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.data == null) {
                                      return const Text(
                                        "Tidak ada data absensi hari ini",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ), // Teks abu-abu
                                      );
                                    } else {
                                      final data = snapshot.data!.data!;
                                      if (data.status?.toLowerCase() ==
                                          'izin') {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tanggal: ${data.attendanceDate != null ? DateFormat('dd MMM yyyy').format(data.attendanceDate!) : '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors
                                                    .black87, // Teks hitam sedikit pudar
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            const Text(
                                              'Status: Izin',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors
                                                    .orange, // Tetap orange untuk status izin
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Alasan: ${data.alasanIzin ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tanggal: ${data.attendanceDate != null ? DateFormat('dd MMM yyyy').format(data.attendanceDate!) : '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Check In: ${data.checkInTime ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Lokasi In: ${data.checkInAddress ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Check Out: ${data.checkOutTime ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Lokasi Out: ${data.checkOutAddress ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== DASHBOARD MENU ======
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100], // Background abu-abu muda
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDashboardItem(
                            icon: Icons.edit,
                            title: "Edit Profil",
                            subtitle: "Perbarui data pribadi",
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    initialName: profile.data?.name ?? '',
                                    initialEmail: profile.data?.email ?? '',
                                    initialGender:
                                        profile.data?.jenisKelamin ?? '',
                                    initialBatchId:
                                        profile.data?.batch?.id?.toString() ??
                                        '',
                                    initialTrainingId:
                                        profile.data?.training?.id
                                            ?.toString() ??
                                        '',
                                  ),
                                ),
                              );

                              if (result == true) {
                                setState(() {
                                  _futureProfile =
                                      ProfileApiService.fetchProfile(); // Refresh profile
                                });
                              }
                            },
                          ),
                          const Divider(color: Colors.grey), // Divider abu-abu
                          _buildDashboardItem(
                            icon: Icons.image,
                            title: "Edit Foto Profil",
                            subtitle: "Ganti foto profil kamu",
                            onTap: () {
                              // Aksi ganti foto profil
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== LOGOUT BUTTON ======
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ), // Ikon logout hitam
                      title: const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.black),
                      ), // Teks keluar hitam
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ), // Ikon panah abu-abu
                      onTap: () async {
                        await PreferenceHandler.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Loginscreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Mengubah warna ikon dan teks pada _buildDashboardItem
  Widget _buildDashboardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.black), // Ikon hitam
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ), // Teks judul hitam
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ), // Teks subtitle abu-abu
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ), // Ikon panah abu-abu
      onTap: onTap,
    );
  }
}

// Menyesuaikan warna _StatCard
class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(
            0.1,
          ), // Tetap menggunakan warna input dengan opacity
          child: Icon(Icons.check, color: color), // Ikon dengan warna input
        ),
        const SizedBox(height: 4),
        Text(
          "$count",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color, // Teks dengan warna input
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ), // Teks label hitam
      ],
    );
  }
}
