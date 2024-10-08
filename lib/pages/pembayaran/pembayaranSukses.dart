import 'dart:async';
import 'package:casadienta_dental/pages/navbar/navbar.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
// import 'package:casadienta_dental/pages/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PembayaranSuksesPage extends StatefulWidget {
  @override
  _PembayaranSuksesPageState createState() => _PembayaranSuksesPageState();
}

class _PembayaranSuksesPageState extends State<PembayaranSuksesPage> {
  late bool showSpinkit;

  @override
  void initState() {
    super.initState();
    showSpinkit = true;

    // Menunggu selama 3 detik sebelum menampilkan animasi Lottie
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSpinkit = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: showSpinkit
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFoldingCube(
                    color: AppColors.primaryColor,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text('Sedang memproses...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/AnimationSuccess.json',
                    repeat: false,
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavBar(initialPageIndex: 3),
                          ));
                      // Tambahkan logika untuk tombol login di sini
                    },
                    child: Text(
                      'Riwayat Janji Temu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PembayaranSuksesPage(),
  ));
}
