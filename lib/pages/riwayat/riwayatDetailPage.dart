import 'package:casadienta_dental/pages/riwayat/widget/details_History_Widget.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:flutter/material.dart';

class detailsHistory extends StatefulWidget {
  final String imagePath;
  final int idLayanan;
  final int idUser;
  final String? nama_dokter;
  final String layanan;
  final String harga;
  final String tanggal;
  final String waktu;
  final String status;
  final String? hasil_analisa;
  final String? saran_layanan;

  const detailsHistory({
    Key? key,
    required this.imagePath,
    required this.idLayanan,
    required this.idUser,
    this.nama_dokter,
    required this.layanan,
    required this.harga,
    required this.tanggal,
    required this.waktu,
    required this.status,
    this.hasil_analisa,
    this.saran_layanan,
  }) : super(key: key);

  @override
  State<detailsHistory> createState() => _detailsHistoryState();
}

class _detailsHistoryState extends State<detailsHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          'Detail Janji Temu',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: DetailsHistoryWidget(
        imagePath: widget.imagePath,
        idLayanan: widget.idLayanan,
        idUser: widget.idUser,
        nama_dokter: widget.nama_dokter ?? '-',
        layanan: widget.layanan,
        harga: widget.harga,
        tanggal: widget.tanggal,
        waktu: widget.waktu,
        status: widget.status,
        hasil_analisa: widget.hasil_analisa ?? '-',
        saran_layanan: widget.saran_layanan ?? '-',
      ),
    );
  }
}
