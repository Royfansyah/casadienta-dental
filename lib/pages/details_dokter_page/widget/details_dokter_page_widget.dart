// import 'package:casadienta_dental/pages/janji_temu/janji_temu.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DetailsDokterPageWidget extends StatelessWidget {
  final String imagePath;
  final int idDokter;
  final String nama_dokter;
  final String pengalaman;
  final String deskripsi;

  const DetailsDokterPageWidget({
    Key? key,
    required this.imagePath,
    required this.idDokter,
    required this.nama_dokter,
    required this.pengalaman,
    required this.deskripsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(nama_dokter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            )),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 225,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.primaryColor, width: 5),
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Text(
                              nama_dokter,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              // '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(double.parse(harga))}',
                              '$pengalaman Tahun',
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 0.5,
            indent: 13,
            endIndent: 13,
            color: Colors.black,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 13, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 13, right: 13),
                          child: Text(
                            deskripsi,
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     child: Center(
                //       child: Container(
                //         width: 400,
                //         height: 60,
                //         // decoration: BoxDecoration(
                //         //     color: const Color.fromARGB(111, 130, 130, 130),
                //         //     // border: Border.all(color: Colors.black),
                //         //     borderRadius: BorderRadius.circular(30)),
                //         child: Row(
                //           children: <Widget>[
                //             Expanded(
                //               child: Container(
                //                 height: 35,
                //                 child: ElevatedButton(
                //                   onPressed: () {
                //                     // Aksi ketika button diklik
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => AppointmentPage(
                //                                 idLayanan: idLayanan,
                //                                 layanan: layanan,
                //                                 harga: harga,
                //                               )),
                //                     );
                //                   },
                //                   child: Text(
                //                     'Buat Janji Temu',
                //                     style: TextStyle(
                //                       fontSize: 14,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                   style: ElevatedButton.styleFrom(
                //                     backgroundColor: AppColors.primaryColor,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(10),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
