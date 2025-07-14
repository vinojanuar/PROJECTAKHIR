import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectakhir/api/profile_service.dart';
import 'package:projectakhir/helper/preference.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialBatchId;
  final String initialTrainingId;
  final String initialGender;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialBatchId,
    required this.initialTrainingId,
    required this.initialGender,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool isUploadingPhoto = false;
  String _selectedGender = 'L';
  String _selectedBatchId = '1';
  String _selectedTrainingId = '1';

  final bool _isLoading = false;
  File? _selectedImage;

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
    _selectedBatchId = widget.initialBatchId;
    _selectedTrainingId = widget.initialTrainingId;
    _selectedGender = widget.initialGender;
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      File file = File(pickedFile.path);
      String? token = await PreferenceHandler.getToken();

      await ProfileApiService.uploadProfilePhoto(
        token: token!,
        photoFile: file,
      );

      setState(() {
        isUploadingPhoto = false;
      });
    } catch (e) {
      setState(() {
        isUploadingPhoto = false;
      });

      print("Upload error: $e");
    }
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _isLoading = true);

  //   try {
  //     final result = await ProfileApiService.editProfile(
  //       name: _nameController.text.trim(),
  //       email: widget.initialEmail,
  //       jenisKelamin: widget.initialGender,
  //       batchId: widget.initialBatchId,
  //       trainingId: widget.initialTrainingId,
  //     );

  //     if (_selectedImage != null) {
  //       await ProfileApiService.uploadProfilePhoto(_selectedImage!);
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result.message ?? "Profil berhasil diperbarui"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     Navigator.pop(context, true);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Gagal memperbarui profil: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage(
                                'assets/images/raflii_1752466740.png',
                              )
                              as ImageProvider,
                    child: _selectedImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _pickAndUploadPhoto,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: false,
                style: const TextStyle(color: Colors.black),
                decoration: _disabledDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: null,
                decoration: _disabledDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBatchId,
                items: _batchOptions.map((batch) {
                  return DropdownMenuItem<String>(
                    value: batch['id'].toString(), // ⬅️ konversi ke String
                    child: Text(batch['name']),
                  );
                }).toList(),
                onChanged: null,
                decoration: _disabledDecoration(labelText: 'Batch'),
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTrainingId,
                items: _trainingOptions.map((training) {
                  return DropdownMenuItem<String>(
                    value: training['id'].toString(), // ⬅️ konversi ke String
                    child: Text(training['name']),
                  );
                }).toList(),
                onChanged: null,
                decoration: _disabledDecoration(labelText: 'Training'),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _pickAndUploadPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        floatingLabelStyle: const TextStyle(color: Colors.black),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
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

  InputDecoration _disabledDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[700]),
      floatingLabelStyle: const TextStyle(color: Colors.black),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
