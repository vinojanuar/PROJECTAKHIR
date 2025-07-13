import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectakhir/api/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialBatchId;
  final String initialTrainingId;
  final String initialGender;

  const EditProfileScreen({
    Key? key,
    required this.initialName,
    required this.initialEmail,
    required this.initialBatchId,
    required this.initialTrainingId,
    required this.initialGender,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedGender = 'L'; // Default to L if not provided
  String _selectedBatchId = '1'; // Default value if not provided
  String _selectedTrainingId = '1'; // Default value if not provided

  bool _isLoading = false;
  File? _selectedImage;

  // Anda perlu menyediakan daftar batch dan training yang sebenarnya dari API
  // Untuk tujuan styling, saya akan menggunakan daftar dummy.
  final List<Map<String, dynamic>> _batchOptions = [
    {'id': '1', 'name': 'Batch A'},
    {'id': '2', 'name': 'Batch B'},
    {'id': '3', 'name': 'Batch C'},
  ];

  final List<Map<String, dynamic>> _trainingOptions = [
    {'id': '1', 'name': 'Flutter Dasar'},
    {'id': '2', 'name': 'Desain UI/UX'},
    {'id': '3', 'name': 'Manajemen Proyek'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);

    // Pastikan initial ID yang diterima ada di dalam list options
    _selectedBatchId =
        _batchOptions.any((batch) => batch['id'] == widget.initialBatchId)
        ? widget.initialBatchId
        : _batchOptions.first['id']; // Fallback to first if not found

    _selectedTrainingId =
        _trainingOptions.any(
          (training) => training['id'] == widget.initialTrainingId,
        )
        ? widget.initialTrainingId
        : _trainingOptions.first['id']; // Fallback to first if not found

    _selectedGender = widget.initialGender;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final result = await ProfileApiService.editProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        jenisKelamin: _selectedGender,
        batchId: _selectedBatchId,
        trainingId: _selectedTrainingId,
      );

      if (_selectedImage != null) {
        // Asumsi uploadProfilePhoto menerima File
        await ProfileApiService.uploadProfilePhoto(_selectedImage!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? "Profil berhasil diperbarui"),
          backgroundColor: Colors.green, // Snack bar hijau untuk sukses
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui profil: ${e.toString()}"),
          backgroundColor: Colors.red, // Snack bar merah untuk error
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar hitam
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ), // Teks putih
        iconTheme: const IconThemeData(color: Colors.white), // Ikon putih
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60, // Ukuran avatar sedikit lebih besar
                    backgroundColor:
                        Colors.grey[200], // Background abu-abu muda
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage('assets/images/default_profile.png')
                              as ImageProvider,
                    child:
                        _selectedImage ==
                            null // Fallback if no image path provided
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    // Posisi tombol edit
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      // Circle around the icon button
                      radius: 20,
                      backgroundColor: Colors.black, // Background hitam
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ), // Ikon putih
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Spasi lebih besar
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdownFormField<String>(
                value: _selectedGender,
                labelText: 'Jenis Kelamin',
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (value) => setState(() => _selectedGender = value!),
              ),
              const SizedBox(height: 16),
              // Contoh Dropdown untuk Batch (Anda harus mengisi `items` dari data API nyata)
              _buildDropdownFormField<String>(
                value: _selectedBatchId,
                labelText: 'Batch',
                items: _batchOptions.map((batch) {
                  return DropdownMenuItem<String>(
                    value: batch['id'],
                    child: Text(batch['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBatchId = value!),
              ),
              const SizedBox(height: 16),
              // Contoh Dropdown untuk Training (Anda harus mengisi `items` dari data API nyata)
              _buildDropdownFormField<String>(
                value: _selectedTrainingId,
                labelText: 'Training',
                items: _trainingOptions.map((training) {
                  return DropdownMenuItem<String>(
                    value: training['id'],
                    child: Text(training['name']),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedTrainingId = value!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background hitam
                    foregroundColor: Colors.white, // Text putih
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  // Helper method for consistent TextFormField styling
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ), // Label saat fokus
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }

  // Helper method for consistent DropdownButtonFormField styling
  Widget _buildDropdownFormField<T>({
    required T value,
    required String labelText,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ), // Label saat fokus
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
