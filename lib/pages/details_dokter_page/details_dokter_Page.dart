import 'package:casadienta_dental/pages/details_dokter_page/widget/details_dokter_page_widget.dart';
import 'package:flutter/material.dart';

class DetailsDokterPage extends StatefulWidget {
  final String imagePath;
  final int idLayanan;
  final String layanan;
  final String harga;
  final String penjelasan;

  const DetailsDokterPage({
    Key? key,
    required this.imagePath,
    required this.idLayanan,
    required this.layanan,
    required this.harga,
    required this.penjelasan,
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
        idLayanan: widget.idLayanan,
        layanan: widget.layanan,
        harga: widget.harga,
        penjelasan: widget.penjelasan,
      ),
    );
  }
}
