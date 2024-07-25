import 'package:casadienta_dental/pages/details_dokter_page/widget/details_dokter_page_widget.dart';
import 'package:flutter/material.dart';

class DetailsDokterPage extends StatefulWidget {
  final String imagePath;
  final int idDokter;
  final String nama_dokter;
  final String pengalaman;
  final String deskripsi;

  const DetailsDokterPage({
    Key? key,
    required this.imagePath,
    required this.idDokter,
    required this.nama_dokter,
    required this.pengalaman,
    required this.deskripsi,
  }) : super(key: key);

  @override
  State<DetailsDokterPage> createState() => _DetailsDokterPageState();
}

class _DetailsDokterPageState extends State<DetailsDokterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Deskripsi',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: AppColors.primaryColor,
      //       )),
      //   centerTitle: true,
      // ),
      body: DetailsDokterPageWidget(
        imagePath: widget.imagePath,
        idDokter: widget.idDokter,
        nama_dokter: widget.nama_dokter,
        pengalaman: widget.pengalaman,
        deskripsi: widget.deskripsi,
      ),
    );
  }
}
