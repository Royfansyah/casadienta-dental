import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:casadienta_dental/pages/profile/widget/user_profile.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Models
class UserData {
  final String namaUser;
  final String fotoUser;
  final String jenisKelamin;
  final String noTelepon;
  final String tempatLahir;
  final String tanggalLahir;
  final String alamat;

  UserData({
    required this.namaUser,
    required this.fotoUser,
    required this.jenisKelamin,
    required this.noTelepon,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      namaUser: json['nama_user'] ?? '-',
      fotoUser: json['foto_user'] ?? '-',
      jenisKelamin: json['jenis_kelamin'] ?? '-',
      noTelepon: json['no_telepon'] ?? '-',
      tempatLahir: json['tempat_lahir'] ?? '-',
      tanggalLahir: json['tanggal_lahir'] ?? '-',
      alamat: json['alamat'] ?? '-',
    );
  }
}

class InfoAkun extends StatefulWidget {
  const InfoAkun({Key? key}) : super(key: key);

  @override
  State<InfoAkun> createState() => _InfoAkunState();
}

class _InfoAkunState extends State<InfoAkun> {
  bool isTapped = false;
  bool isEditing = false;
  late Future<UserData> futureUserData;
  late TextEditingController namaController;
  late TextEditingController noTeleponController;
  late TextEditingController jenisKelaminController;
  late TextEditingController tempatLahirController;
  late TextEditingController tanggalLahirController;
  late TextEditingController alamatController;
  String? _jenisKelamin;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  Future<UserData> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final idGoogle = user.uid;
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/api/User/$idGoogle'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final userDataJson = decodedJson['data'];
      return UserData.fromJson(userDataJson);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _editUserData(UserData userData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final idGoogle = user.uid;
    final url = '${ApiConfig.baseUrl}/api/User/$idGoogle';

    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode({
        'nama_user': namaController.text,
        'no_telepon': noTeleponController.text,
        'jenis_kelamin': jenisKelaminController.text,
        'tempat_lahir': tempatLahirController.text,
        'tanggal_lahir': tanggalLahirController.text,
        'alamat': alamatController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Update was successful
      setState(() {
        isEditing = false;
      });
      // Agar saat data terupdate maka akan memanggil fetchUserData() kembali untuk mendapatkan data terbaru.
      futureUserData = fetchUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data berhasil diperbarui',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Failed to update user data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi data untuk menyimpan perubahan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('Failed to update user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          'Info Akun',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserData>(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    isEditing
                        ? _buildEditFields(userData)
                        : Column(
                            children: [
                              UserProfile(
                                namaUser: userData
                                    .namaUser, // Menggunakan namaUser untuk UserProfile
                                fotoUser: userData.fotoUser,
                                user: FirebaseAuth.instance.currentUser,
                                onPressed: () => _showFullscreenImage(
                                    context, userData.fotoUser),
                              ),
                              const SizedBox(height: 4),
                              // Add edit button
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = true;
                                    // Initialize controllers with current data
                                    namaController = TextEditingController(
                                        text: userData.namaUser);
                                    noTeleponController = TextEditingController(
                                        text: userData.noTelepon);
                                    jenisKelaminController =
                                        TextEditingController(
                                            text: userData.jenisKelamin);
                                    tempatLahirController =
                                        TextEditingController(
                                            text: userData.tempatLahir);
                                    tanggalLahirController =
                                        TextEditingController(
                                            text: userData.tanggalLahir);
                                    alamatController = TextEditingController(
                                        text: userData.alamat);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      AppColors.primaryColor, // Ubah warna teks
                                ),
                                child: Text('Edit Profil'),
                              ),
                              const SizedBox(height: 4),
                              _buildInfoField('Nama:', userData.namaUser),
                              _buildInfoField('No. Telp:', userData.noTelepon),
                              _buildInfoField(
                                  'Jenis Kelamin:', userData.jenisKelamin),
                              _buildInfoField(
                                  'Tempat Lahir:', userData.tempatLahir),
                              _buildInfoField(
                                  'Tanggal Lahir:', userData.tanggalLahir),
                              _buildInfoField('Alamat:', userData.alamat),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity, // Lebar penuh
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditFields(UserData userData) {
    return Column(
      children: [
        // Editable fields
        TextField(
          controller: namaController,
          decoration: InputDecoration(labelText: 'Nama'),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: noTeleponController,
          decoration: InputDecoration(labelText: 'No. Telepon'),
          keyboardType: TextInputType.phone, // Keyboard type untuk input angka
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter
                .digitsOnly // Hanya menerima digit (angka)
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // DropdownButtonFormField<String>(
        //   dropdownColor: Colors.white,
        //   value: _selectedJenisKelamin ?? jenisKelaminController.text,
        //   onChanged: (newValue) {
        //     setState(() {
        //       _selectedJenisKelamin = newValue;
        //       jenisKelaminController.text = newValue!;
        //     });
        //   },
        //   decoration: InputDecoration(
        //     labelText: 'Jenis Kelamin',
        //   ),
        //   items: ['Laki-laki', 'Perempuan']
        //       .map((value) => DropdownMenuItem<String>(
        //             value: value,
        //             child: Text(value),
        //           ))
        //       .toList(),
        // ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Jenis Kelamin',
            style: TextStyle(fontSize: 13.0),
          ),
        ),
        RadioListTile<String>(
          title: const Text(
            'Laki-laki',
            style: TextStyle(fontSize: 15.0),
          ),
          value: 'Laki-laki',
          groupValue: _jenisKelamin,
          onChanged: (value) {
            setState(() {
              _jenisKelamin = value;
              jenisKelaminController.text = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text(
            'Perempuan',
            style: TextStyle(fontSize: 15.0),
          ),
          value: 'Perempuan',
          groupValue: _jenisKelamin,
          onChanged: (value) {
            setState(() {
              _jenisKelamin = value;
              jenisKelaminController.text = value!;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: tempatLahirController,
          decoration: InputDecoration(labelText: 'Tempat Lahir'),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: tanggalLahirController,
          decoration: InputDecoration(
            labelText: 'Tanggal Lahir',
            suffixIcon: GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  // Format tanggal menggunakan DateFormat
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  tanggalLahirController.text =
                      formattedDate; // Update controller value
                }
              },
              child: Icon(Icons.calendar_today),
            ),
          ),
          keyboardType: TextInputType.datetime, // Trigger datetime keyboard
          readOnly: true, // Ensure user can only pick date through date picker
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: alamatController,
          decoration: InputDecoration(labelText: 'Alamat'),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Memposisikan di tengah
          children: [
            ElevatedButton(
              onPressed: () => _editUserData(userData),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primaryColor, // Ubah warna teks
              ),
              child: Text('Simpan'),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primaryColor, // Ubah warna teks
              ),
              child: Text('Batal'),
            ),
          ],
        ),
      ],
    );
  }
}

void _showFullscreenImage(BuildContext context, String photoUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 300,
          width: 300,
          child: SizedBox(
            width: 150.0,
            height: 150.0,
            child: photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/img/empty-user.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );
    },
  );
}
