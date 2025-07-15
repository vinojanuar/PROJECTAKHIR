import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectakhir/api/absensi_service.dart';
import 'package:projectakhir/model/izin_model.dart'; // Pastikan path benar

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alasanController = TextEditingController();
  bool _isSubmitting = false; // To manage button state during submission

  Future<void> _ajukanIzin() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true); // Set submitting state to true

    try {
      final now = DateTime.now();
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(now); // Format current date

      // Call the API service to post izin (leave request)
      Izin? result = await AbsenApiService.postIzin(
        date: formattedDate,
        alasanIzin: _alasanController.text
            .trim(), // Trim whitespace from reason
      );

      // Check API response message
      if (result != null && result.message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message!)));
        // --- Mengembalikan `true` saat sukses ---
        Navigator.pop(context, true); // Pop screen and return true
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal mengajukan izin")));
        // --- Mengembalikan `false` saat gagal ---
        Navigator.pop(context, false); // Pop screen and return false
      }
    } catch (e) {
      // Catch any errors during the API call
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
      // --- Mengembalikan `false` saat error ---
      Navigator.pop(context, false); // Pop screen and return false
    } finally {
      setState(() => _isSubmitting = false); // Always reset submitting state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF4F46E5),
        elevation: 0,
        title: const Text(
          "Ajukan Izin",
          style: TextStyle(
            color: Color.fromARGB(255, 231, 228, 228),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Assign form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Alasan Izin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _alasanController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tulis alasan izin di sini...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty
                    ? 'Alasan tidak boleh kosong'
                    : null, // Validation rule
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F46E5),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : _ajukanIzin, // Disable button while submitting
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) // Show loader
                      : const Text(
                          "Ajukan Izin",
                          style: TextStyle(color: Colors.white),
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
