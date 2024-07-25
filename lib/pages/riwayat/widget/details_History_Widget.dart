import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:casadienta_dental/config/api_config.dart';

class DetailsHistoryWidget extends StatelessWidget {
  final String imagePath;
  final int idLayanan;
  final int idUser;
  final String layanan;
  final String nama_dokter;
  final String harga;
  final String tanggal;
  final String waktu;
  final String status;
  final String hasil_analisa;
  final String saran_layanan;

  DetailsHistoryWidget({
    Key? key,
    required this.imagePath,
    required this.idLayanan,
    required this.idUser,
    required this.layanan,
    required this.nama_dokter,
    required this.harga,
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.hasil_analisa,
    required this.saran_layanan,
  }) : super(key: key);

  // Fungsi untuk menampilkan jendela popup dan mengirim ulasan
  void _showReviewDialog(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Berikan Ulasan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp(r'[1-5]')),
                ],
                decoration: InputDecoration(
                  hintText: 'Nilai Ulasan (1-5)',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis ulasan Anda di sini',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final komentar = reviewController.text;
                final nilaiUlasan = ratingController.text;
                final tanggalUlasan = DateTime.now().toIso8601String();

                if (komentar.isNotEmpty && nilaiUlasan.isNotEmpty) {
                  try {
                    // Kirim ulasan ke endpoint API
                    final response = await http.post(
                      Uri.parse('${ApiConfig.baseUrl}/api/Ulasan'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, dynamic>{
                        'id_layanan': idLayanan,
                        'id_user': idUser,
                        'nilai_ulasan': int.parse(nilaiUlasan),
                        'komentar': komentar,
                        'tanggal_ulasan': tanggalUlasan,
                      }),
                    );

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ulasan berhasil dikirim',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Anda sudah mengisi ulasan ini',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Terjadi kesalahan: $e',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nilai dan ulasan tidak boleh kosong'),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Implementasi widget
    return SingleChildScrollView(
      child: Column(
        children: [
          // Konten widget
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor, width: 5),
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Text(
                        layanan,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Status
          Container(
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              status,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          if (status == 'Selesai')
            ElevatedButton(
              onPressed: () => _showReviewDialog(context),
              child: Text('Berikan Ulasan'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          const Divider(
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          if (status == 'Selesai') ...[
            const Text(
              'Dokter',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 30,
              margin: EdgeInsets.only(left: 70, right: 70),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nama_dokter,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
          // Harga
          const SizedBox(height: 10),
          const Text(
            'Harga',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                      .format(double.parse(harga)),
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
          // Tanggal
          const SizedBox(height: 20),
          const Text(
            'Tanggal',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatDate(tanggal),
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
          // Waktu
          const SizedBox(height: 20),
          const Text(
            'Jam',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatTime(waktu),
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
          // Tampilkan saran layanan hanya jika layanan adalah "Konsultasi Gigi"
          // if (layanan == 'Konsultasi Gigi') ...[
          const SizedBox(
            height: 6,
          ),
          const Divider(
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol untuk Saran Layanan
              Center(
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => _showSaranLayanan(context, saran_layanan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black.withOpacity(0.3),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Saran Layanan',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // Tombol untuk hasil analisa
              if (status == 'Selesai')
                Center(
                  child: SizedBox(
                    height: 30, // Tinggi tombol
                    child: ElevatedButton(
                      onPressed: () =>
                          _showHasilAnalisa(context, hasil_analisa),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Lihat Hasil Analisa',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk memformat tanggal dalam bahasa Indonesia
String formatDate(String dateString) {
  // Parse tanggal menjadi objek DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Format tanggal sesuai dengan bahasa Indonesia
  String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);

  return formattedDate;
}

// Fungsi untuk memformat waktu dalam bahasa Indonesia
String formatTime(String timeString) {
  // Gabungkan string waktu dengan string tanggal dummy
  String dateTimeString = '1970-01-01 $timeString';
  DateTime time = DateTime.parse(dateTimeString);
  String formattedTime =
      DateFormat.Hm('id_ID').format(time) + ' WIB'; // Format jam:menit
  return formattedTime;
}

// Fungsi untuk warna status
Color _getStatusColor(String status) {
  switch (status) {
    case 'Menunggu Konfirmasi':
      return Colors.orange.withOpacity(0.8);
    case 'Menunggu Kunjungan':
      return Colors.blue.withOpacity(0.8);
    case 'Selesai':
      return Colors.green.withOpacity(0.8);
    case 'Tidak Valid':
      return Colors.red.withOpacity(0.8);
    default:
      return Colors.grey.withOpacity(0.8);
  }
}

void _showHasilAnalisa(BuildContext context, String hasilAnalisa) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Hasil Analisa'),
        content: SingleChildScrollView(
          child: Text(hasilAnalisa),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showSaranLayanan(BuildContext context, String saranLayanan) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Saran Layanan'),
        content: SingleChildScrollView(
          child: Text(saranLayanan),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
// Metode Pembayaran
          // const SizedBox(height: 20),
          // const Text(
          //   '-',
          //   style: TextStyle(
          //     // decoration: TextDecoration.underline,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 17,
          //   ),
          // ),
          // const SizedBox(height: 5),
          // Container(
          //   height: 30,
          //   margin: EdgeInsets.only(left: 70, right: 70),
          //   decoration: BoxDecoration(
          //     color: AppColors.primaryColor,
          //     border: Border.all(color: AppColors.primaryColor),
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.3),
          //         spreadRadius: 1,
          //         blurRadius: 5,
          //         offset: Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         '',
          //         style: TextStyle(color: Colors.white, fontSize: 17),
          //       ),
          //     ],
          //   ),
          // ),