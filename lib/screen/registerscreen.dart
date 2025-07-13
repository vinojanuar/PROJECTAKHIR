import 'package:flutter/material.dart';
import 'package:projectakhir/api/user_api.dart';
import 'package:projectakhir/screen/loginscreen.dart';

class Regisscreen extends StatefulWidget {
  const Regisscreen({super.key});

  @override
  State<Regisscreen> createState() => _RegisscreenState();
}

class _RegisscreenState extends State<Regisscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedGender = "Laki-laki";
  bool _obscureText = true;

  int? selectedBatchId;
  int? selectedTrainingId;

  List<dynamic> batchList = [];
  List<dynamic> trainingList = [];

  final UserService userService =
      UserService(); // Pastikan ini sudah diimplementasikan dengan benar
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBatchAndTraining();
  }

  Future<void> fetchBatchAndTraining() async {
    // Simulasi pengambilan data batch dan training
    await Future.delayed(const Duration(seconds: 1)); // Delay simulasi API
    setState(() {
      batchList = [
        {'id': 1, 'batch_ke': 'Batch 1'},
        {'id': 2, 'batch_ke': 'Batch 2'},
        {'id': 3, 'batch_ke': 'Batch 3'},
      ];
      trainingList = [
        {'id': 101, 'title': 'Flutter Fundamental'},
        {'id': 102, 'title': 'Dart Advanced'},
        {'id': 103, 'title': 'UI/UX Design for Mobile'},
      ];
    });
    // try {
    //   final batchData = await userService.getListBatch();
    //   final trainingData = await userService.getListTraining();

    //   setState(() {
    //     batchList = batchData['data'] ?? [];
    //     trainingList = trainingData['data'] ?? [];
    //   });
    // } catch (e) {
    //   print("Error fetching batch/training data: $e");
    // }
  }

  void register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedBatchId == null ||
        selectedTrainingId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi!")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulasi API call
    final res = await userService.registerUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      batchId: selectedBatchId!,
      trainingId: selectedTrainingId!,
      jenisKelamin: selectedGender == "Laki-laki" ? "L" : "P",
    );

    if (res["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register berhasil! Silahkan login."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maaf, ${res["message"] ?? "Terjadi kesalahan"}"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar putih
        elevation: 0, // Tanpa shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ikon hitam
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Loginscreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Register Account",
                style: TextStyle(
                  fontSize: 24, // Ukuran judul lebih besar
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Teks hitam
                ),
              ),
              const SizedBox(height: 32), // Spasi lebih besar
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Nama",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown Batch
              DropdownButtonFormField<int>(
                value: selectedBatchId,
                style: const TextStyle(
                  color: Colors.black,
                ), // Teks dropdown item
                dropdownColor: Colors.white, // Latar belakang dropdown
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ), // Ikon dropdown
                items: batchList.map<DropdownMenuItem<int>>((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(item['batch_ke']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBatchId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Batch",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown Training
              DropdownButtonFormField<int>(
                value: selectedTrainingId,
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: trainingList.map<DropdownMenuItem<int>>((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        item['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTrainingId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Training",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown Jenis Kelamin
              DropdownButtonFormField<String>(
                value: selectedGender,
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: ["Laki-laki", "Perempuan"].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Jenis Kelamin",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Tombol hitam
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, // Indikator loading putih
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white, // Teks tombol putih
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
