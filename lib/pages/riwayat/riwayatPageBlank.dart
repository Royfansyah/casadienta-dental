import 'package:flutter/material.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';

class HistoryPageBlank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          'Riwayat Janji Temu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
