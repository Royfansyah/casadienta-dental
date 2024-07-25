import 'package:casadienta_dental/pages/details_dokter_page/details_dokter_Page.dart';
import 'package:flutter/material.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:casadienta_dental/pages/details_layanan_page/details_layanan_Page.dart';
import 'package:intl/intl.dart';

class DaftarDokterCard extends StatelessWidget {
  final String imagePath;
  final int idDokter;
  final String nama_dokter;
  final String pengalaman;
  final String deskripsi;
  final bool isAvailable;

  DaftarDokterCard({
    required this.imagePath,
    required this.idDokter,
    required this.nama_dokter,
    required this.pengalaman,
    required this.deskripsi,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: AppColors.primaryColor),
        // shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Mengubah alignment agar tombol berada di atas
            children: [
              // Foto Layanan
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(11)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Informasi dokter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama_dokter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                    ),
                    Text(
                      '$pengalaman Tahun',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      _truncateDescription(deskripsi, 20),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Tombol status "Available" dan "Book"
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsDokterPage(
                    imagePath: imagePath,
                    idDokter: idDokter,
                    nama_dokter: nama_dokter,
                    pengalaman: pengalaman,
                    deskripsi: deskripsi,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              // Set lebar ke infinity untuk memenuhi panjang baris
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _truncateDescription(String description, int maxWords) {
  List<String> words = description.split(' ');
  if (words.length > maxWords) {
    words = words.sublist(0, maxWords);
    return words.join(' ') + '...';
  } else {
    return description;
  }
}
