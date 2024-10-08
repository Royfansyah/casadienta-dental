import 'package:casadienta_dental/config/api_config.dart';
import 'package:casadienta_dental/pages/layanan/layananPage.dart';
// import 'package:casadienta_dental/pages/categories/categories.dart';
import 'package:casadienta_dental/pages/layanan/widget/daftar_layanan.dart';
import 'package:casadienta_dental/pages/dashboard/widget/user_profile.dart';
import 'package:casadienta_dental/pages/details_dokter_page/details_dokter_page.dart';
import 'package:casadienta_dental/pages/dokter/dokterPage.dart';
import 'package:casadienta_dental/pages/navbar/navbar.dart';
import 'package:casadienta_dental/pages/ulasan/ulasanPage.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
// import 'package:casadienta_dental/pages/navbar/navbar.dart';
// import 'package:casadienta_dental/pages/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:casadienta_dental/pages/dashboard/widget/ulasan_card.dart';
import 'package:casadienta_dental/pages/dashboard/widget/dokter_card.dart';
// import 'package:casadienta_dental/pages/login/login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late User? user;
  late Future<Map<String, dynamic>> _serviceDataUser;
  late Future<List<dynamic>> _serviceDataDokter;
  late Future<List<dynamic>> _serviceDataLayanan;
  late Future<List<dynamic>> _serviceDataUlasan;

  Future<Map<String, dynamic>> getDataUser(String idGoogle) async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/User/$idGoogle');
    final response = await http.get(url);
    var data = jsonDecode(response.body);
    print('User data: $data'); // Log data untuk debugging
    return data;
  }

  Future<List> getDataDokter() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Dokter');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<List> getDataUlasan() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Ulasan');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<List> getDataLayanan() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Layanan');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    _serviceDataDokter = getDataDokter();
    _serviceDataUlasan = getDataUlasan();
    _serviceDataLayanan = getDataLayanan();
    super.initState();
    initializeUser();
  }

  void initializeUser() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String idGoogle = user!.uid;
      _serviceDataUser = getDataUser(idGoogle);
    }
    _serviceDataDokter = getDataDokter();
    _serviceDataUlasan = getDataUlasan();
    _serviceDataLayanan = getDataLayanan();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: SingleChildScrollView(
          child: FutureBuilder<List<dynamic>>(
            future: _serviceDataDokter,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    // Menggunakan Expanded di sekitar widget Lottie.asset
                    const SizedBox(
                      height: 267,
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
                List<dynamic> serviceList = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _serviceDataUser,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('No data available');
                        } else {
                          var userData = snapshot.data!;
                          return UserProfile(
                            user: user,
                            namaUser: userData['data']['nama_user'],
                          );
                        }
                      },
                    ),
                    // Layanan dan More
                    const Divider(
                      thickness: 0.8,
                      indent: 18,
                      endIndent: 18,
                      color: AppColors.primaryText,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dokter',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              // Tambahkan logika untuk navigasi ke halaman lain di sini
                              // Misalnya, Navigator.push ke halaman baru.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dokter()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 0.0),
                              child: Text(
                                'Lainnya',
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.primaryText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kotak container dengan gambar dan nama layanan
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.0,
                      ),
                      height: 125,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceList.length > 2
                            ? 4
                            : serviceList
                                .length, // Apabila Lebih dari 2 maka tampilkan 4
                        itemBuilder: (context, index) {
                          var service = serviceList[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigasi ke halaman detail dengan membawa data service
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsDokterPage(
                                    imagePath: service['lokasi_gambar'],
                                    idDokter: service['id_dokter'],
                                    nama_dokter: service['nama_user'],
                                    pengalaman:
                                        service['pengalaman'].toString(),
                                    deskripsi: service['deskripsi'],
                                  ),
                                ),
                              );
                            },
                            child: ServiceCard(
                              service['nama_user'],
                              service['lokasi_gambar'],
                            ),
                          );
                        },
                      ),
                    ),
                    // Ulasan
                    Padding(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ulasan',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              // Tambahkan logika untuk navigasi ke halaman lain di sini
                              // Misalnya, Navigator.push ke halaman baru.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ulasan()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: const Text(
                                'Lainnya',
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.primaryText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // List ulasan populer
                    Container(
                      height: 200,
                      child: FutureBuilder<List<dynamic>>(
                        future: _serviceDataUlasan,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Text('No data available');
                          } else {
                            List<dynamic> ulasanList = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ulasanList.length > 6
                                  ? 6
                                  : ulasanList
                                      .length, // Apabila Lebih dari 2 maka tampilkan 4
                              itemBuilder: (context, index) {
                                var ulasan = ulasanList[index];
                                return PopularCard(
                                  layanan: ulasan['nama_layanan'],
                                  idLayanan: ulasan['id_layanan'],
                                  namaUser: ulasan['nama_user'],
                                  imagePath: ulasan['lokasi_gambar'],
                                  review: ulasan['komentar'],
                                  harga: ulasan['harga'].toString(),
                                  deskripsi: ulasan['deskripsi'],
                                  rating: ulasan['nilai_ulasan'],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Popular
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Daftar Layanan',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Tambahkan logika untuk navigasi ke halaman lain di sini
                              // Misalnya, Navigator.push ke halaman baru.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Layanan(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Text(
                                'Lainnya',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: _serviceDataLayanan,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data available');
                        } else {
                          List<dynamic> layananList = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount:
                                layananList.length > 2 ? 2 : layananList.length,
                            itemBuilder: (context, index) {
                              var layanan = layananList[index];
                              return DaftarLayananCard(
                                imagePath: layanan['lokasi_gambar'],
                                idLayanan: layanan['id_layanan'],
                                nama_layanan: layanan['nama_layanan'],
                                harga: layanan['harga'].toString(),
                                deskripsi: layanan['deskripsi'],
                                isAvailable: false,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
