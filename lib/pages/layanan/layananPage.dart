import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:casadienta_dental/pages/layanan/widget/daftar_layanan.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:lottie/lottie.dart';

class Layanan extends StatefulWidget {
  const Layanan({Key? key}) : super(key: key);

  @override
  State<Layanan> createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  late User? user;
  late Future<List<dynamic>> _serviceData;
  late List<dynamic> serviceList = [];
  late List<dynamic> filteredServiceList = [];

  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<List> getData() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Layanan');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _serviceData = getData();
    initializeUser();
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

  void initializeUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  void filterServices(String query) {
    List<dynamic> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = serviceList.where((service) {
        return service['nama_layanan']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } else {
      filteredList = List.from(serviceList);
    }

    setState(() {
      filteredServiceList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color.fromARGB(255, 0, 0, 0),
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          'Daftar Layanan',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  filterServices(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  // Atur padding vertikal
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      20), // Batasi hingga 20 karakter/Huruf
                ],
              ),
            ),
          ),
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
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available');
              } else {
                if (filteredServiceList.isEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: Text(
                            'Layanan tidak ditemukan.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(189, 183, 183, 183),
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        return DaftarLayananCard(
                          imagePath: service['lokasi_gambar'],
                          idLayanan: service['id_layanan'],
                          nama_layanan: service['nama_layanan'],
                          harga: service['harga'].toString(),
                          deskripsi: service['deskripsi'],
                          isAvailable: false,
                        );
                      } else {
                        return _buildLoadMoreIndicator();
                      }
                    },
                  );
                }
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
