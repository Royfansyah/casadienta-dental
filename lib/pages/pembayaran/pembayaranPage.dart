import 'dart:convert';
import 'dart:io';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:casadienta_dental/pages/pembayaran/pembayaranSukses.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PembayaranPage extends StatefulWidget {
  final int idLayanan;
  final String layanan;
  final String harga;
  final String tanggal;
  final String jam;
  const PembayaranPage({
    Key? key,
    required this.idLayanan,
    required this.layanan,
    required this.harga,
    required this.tanggal,
    required this.jam,
  }) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  // dateNow() {
  //   var now = new DateTime.now();
  //   var formatter = new DateFormat('yyyy-MM-dd');
  //   String formattedDate = formatter.format(now);
  //   return formattedDate;
  // }

  // String formatDate(String date) {
  //   DateTime dateTime = DateTime.parse(date);
  //   return DateFormat('yyyy-MM-dd').format(dateTime);
  // }

  int? selectedPaymentMethod;
  // File? _image;

  final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // Function to get id_google of the logged-in user
  Future<String?> getIdGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      User? user = auth.currentUser;

      if (user != null) {
        String idGoogle = user.uid;
        return idGoogle;
      } else {
        return null; // No user is currently logged in
      }
    } catch (e) {
      print("Error getting id_google: $e");
      return null;
    }
  }

  Future<int> fetchUserId(String idGoogle) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/User?id_google=$idGoogle'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response to get the user ID
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData['id_user'];
      } else {
        // Handle errors
        throw Exception('Gagal memuat ID user');
      }
    } catch (e) {
      print("Error fetching user ID: $e");
      throw Exception('Gagal memuat ID pengguna');
    }
  }

  Future<void> kirimDataPemesanan() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Pemesanan');

    // Replace this with the actual user ID retrieval logic
    final String idGoogle = await getIdGoogle() ?? '';

    // Determine payment method based on selectedPaymentMethod
    // String metodePembayaran = '';

    try {
      // Prepare data to be sent to the API
      final Map<String, dynamic> dataPemesanan = {
        'id_layanan': widget.idLayanan,
        'id_user': await fetchUserId(idGoogle),
        'id_google': idGoogle,
        'tanggal_pemesanan': widget.tanggal,
        'waktu_pemesanan': widget.jam,
        'status_pemesanan': 'Menunggu Konfirmasi',
        // 'metode_pembayaran': metodePembayaran,
      };

      // Send data to the API
      final response = await Dio().post(
        url.toString(),
        data: FormData.fromMap(dataPemesanan),
      );

      // Check the response status
      if (response.statusCode! >= 200 && response.statusCode! <= 208) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PembayaranSuksesPage()),
        );
        // tampilkan semua data yang dikirimkan
        print('Berhasil mengirim data: ${response.data}');
      } else {
        // If failed, print an error message or take appropriate action
        print('Gagal mengirim data: ${dataPemesanan}');
        print('Gagal mengirim data: ${response.data}');
        print('Gagal mengirim data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(widget.tanggal);
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: const Text(
          'Pembayaran',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView di sini
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Detail Yang Harus dibayarkan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16.0),
                // tambahkan decoration background
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Layanan',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.layanan,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Waktu',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$formattedDate, ${widget.jam.substring(0, 5)} WIB',
                          // 'Hari ini, 10:00 WIB',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(double.parse(widget.harga))}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text('Silahkan Untuk Melakukan:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('1. Datang ke tempat',
                              style: TextStyle(fontSize: 14)),
                          Text('2. Konfirmasi pembayaran kepada pihak kami',
                              style: TextStyle(fontSize: 14)),
                          Text(
                              '3. Melakukan transaksi pembayaran sesuai dengan yang tertera',
                              style: TextStyle(fontSize: 14)),
                          Text('4. Selesai', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  kirimDataPemesanan();
                  // Panggil fungsi untuk mengambil gambar
                },
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        kirimDataPemesanan();
                        // Panggil fungsi untuk mengambil gambar
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
