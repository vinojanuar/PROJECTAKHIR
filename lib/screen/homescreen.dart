import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue.shade900,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Kehadiran'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 260, // Lebih tinggi supaya muat semua
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 40),
                      Text(
                        'MORNING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Muhammad Rio Akbar',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '123456789',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Spasi bawah setelah Stack
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Distance from place',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '250.43m',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Check In\n07 : 50 : 00",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Check Out\n17 : 50 : 00",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatera Utara',
                          style: TextStyle(fontSize: 14),
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
