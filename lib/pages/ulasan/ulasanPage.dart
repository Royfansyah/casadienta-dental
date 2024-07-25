import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:lottie/lottie.dart';
import 'package:casadienta_dental/pages/ulasan/widget/daftar_ulasan.dart';

class Ulasan extends StatefulWidget {
  const Ulasan({Key? key}) : super(key: key);

  @override
  State<Ulasan> createState() => _UlasanState();
}

class _UlasanState extends State<Ulasan> {
  late Future<List<dynamic>> _serviceData;
  late List<dynamic> serviceList = [];
  late List<dynamic> filteredServiceList = [];

  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<List> getData() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Ulasan');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _serviceData = getData();
    _serviceData.then((data) {
      setState(() {
        serviceList = data;
        filteredServiceList = List.from(serviceList);
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list, load more data
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      await Future.delayed(Duration(seconds: 1));

      // Example: Load more data, here we simulate by adding more items
      List<dynamic> moreData = await getData();
      setState(() {
        serviceList.addAll(moreData);
        filteredServiceList = List.from(serviceList);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          'Daftar Ulasan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.backGroundColor,
      body: ListView(
        children: [
          SizedBox(height: 10),
          const SizedBox(height: 5),
          // FutureBuilder for loading animation
          FutureBuilder<List<dynamic>>(
            future: _serviceData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 175,
                    ),
                    Center(
                      child: Lottie.asset(
                        'assets/lottie/LoadingAnimation.json',
                        repeat: true,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Text('Loading...'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No data available'),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: filteredServiceList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < filteredServiceList.length) {
                      var service = filteredServiceList[index];
                      return DaftarUlasanCard(
                        layanan: service['nama_layanan'],
                        idLayanan: service['id_layanan'],
                        namaUser: service['nama_user'],
                        imagePath: service['lokasi_gambar'],
                        review: service['komentar'],
                        harga: service['harga'].toString(),
                        deskripsi: service['deskripsi'],
                        rating: service['nilai_ulasan'],
                      );
                    } else {
                      return _buildLoadMoreIndicator();
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return _isLoading
        ? Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : SizedBox();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
