import 'dart:convert';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:casadienta_dental/pages/janji_temu/widget/table_calendar.dart';
import 'package:casadienta_dental/pages/pembayaran/pembayaranPage.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final int idLayanan;
  final String layanan;
  final String harga;

  const AppointmentPage({
    Key? key,
    required this.idLayanan,
    required this.layanan,
    required this.harga,
  }) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int selectedValue = -1;
  String jam = '';
  DateTime selectedDate = DateTime.now();
  Map<String, bool> availability = {};

  void onJamSelected(String selectedJam) {
    setState(() {
      jam = selectedJam;
    });
  }

  Future<bool> checkAvailability(String tanggal, String waktu) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/CekPemesanan'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tanggal_pemesanan': tanggal,
        'waktu_pemesanan': waktu,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result[
          'available']; // Assuming the API returns a JSON with a key 'available'
    } else {
      throw Exception('Failed to load availability');
    }
  }

  Future<void> checkAllAvailability() async {
    List<Future<void>> futures = [];
    for (int i = 9; i <= 20; i++) {
      String waktu = '${i.toString().padLeft(2, '0')}:00:00';
      futures.add(checkSingleAvailability(waktu));
    }
    await Future.wait(futures);
  }

  Future<void> checkSingleAvailability(String waktu) async {
    bool available = await checkAvailability(
        selectedDate.toIso8601String().split('T')[0], waktu);
    setState(() {
      availability[waktu] = available;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAllAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: const Text(
          'Janji Temu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendarWidget(
              onDateSelected: (DateTime date) {
                setState(() {
                  selectedDate = date;
                  checkAllAvailability();
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 26.0, top: 10),
                  child: Text(
                    'Waktu yang Tersedia :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(12, (index) {
                    int jam = 9 + index;
                    String waktu = '${jam.toString().padLeft(2, '0')}:00:00';
                    return buildTimeContainer(jam, waktu);
                  }),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          if (jam.isNotEmpty && availability[jam] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PembayaranPage(
                                  idLayanan: widget.idLayanan,
                                  layanan: widget.layanan,
                                  harga: widget.harga,
                                  tanggal: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate),
                                  jam: jam,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.backGroundColor,
                                  title: const Text("Peringatan!"),
                                  content: const Text(
                                      "Silakan pilih waktu yang tersedia."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Selanjutnya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // WIDGET DEFAULT
  Widget buildTimeContainer(int value, String jam) {
    bool? isAvailable = availability[jam];
    DateTime now = DateTime.now();
    DateTime currentDateTime = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, value);

    // Periksa apakah waktu yang ditampilkan sudah lewat
    bool isPastTime = currentDateTime.isBefore(now);

    return InkWell(
      onTap: () {
        if (isAvailable == true && !isPastTime) {
          setState(() {
            selectedValue = value;
            onJamSelected(jam);
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppColors.backGroundColor,
                title: const Text("Peringatan!"),
                content: Text(isPastTime
                    ? "Waktu yang dipilih sudah lewat."
                    : "Waktu yang dipilih sudah tidak tersedia. Silakan pilih waktu yang lain."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPastTime
              ? Colors.grey[300] // Warna untuk waktu yang sudah lewat
              : isAvailable == null
                  ? Colors.grey
                  : isAvailable
                      ? (selectedValue == value
                          ? AppColors.primaryColor // Warna saat dipilih
                          : Colors.green)
                      : Colors.red, // Warna untuk waktu yang tidak tersedia
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          jam.substring(0, 5),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

  // WIDGET DENGAN KONDISI APABILA WAKTU YANG SUDAH LEWAT MAKA TIDAK DAPAT DIPILIH
  // Widget buildTimeContainer(int value, String jam) {
  //   // Mendapatkan waktu saat ini
  //   DateTime now = DateTime.now();
  //   // Mendapatkan jam yang dipilih dari string
  //   int selectedHour = int.parse(jam.substring(0, 2));

  //   // Memeriksa apakah jam yang dipilih sudah lewat atau belum
  //   bool isPastTime = now.hour > selectedHour ||
  //       (now.hour == selectedHour && now.minute >= 0);

  //   return InkWell(
  //     onTap: () {
  //       // Jika waktu yang dipilih belum lewat, update state
  //       if (!isPastTime) {
  //         setState(() {
  //           selectedValue = value;
  //           onJamSelected(jam);
  //         });
  //       } else {
  //         // Jika waktu yang dipilih sudah lewat, tampilkan pesan peringatan
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               backgroundColor: AppColors.backGroundColor,
  //               title: const Text("Peringatan!"),
  //               content: const Text("Waktu sudah lewat."),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("OK"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         color: selectedValue == value
  //             ? AppColors.primaryColor
  //             : (isPastTime
  //                 ? const Color.fromARGB(255, 223, 15, 0)
  //                 : Colors.grey),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Text(
  //         jam.substring(0, 5),
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }
