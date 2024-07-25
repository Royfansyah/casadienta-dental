import 'package:casadienta_dental/pages/dokter/dokterPage.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:casadienta_dental/pages/dashboard/dashboard.dart';
import 'package:casadienta_dental/pages/riwayat/riwayatPage.dart';
import 'package:casadienta_dental/pages/layanan/layananPage.dart';
import 'package:casadienta_dental/pages/navbar/widget/bottom_icon_widget.dart';
import 'package:casadienta_dental/pages/profile/profilePage.dart';
import 'package:casadienta_dental/resource/resource.gen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int initialPageIndex;
  const NavBar({Key? key, required this.initialPageIndex}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // int _selectedIndex = 0;

  late int pageIndex;
  late int initialPageIndex;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    initialPageIndex = widget.initialPageIndex;
    pageIndex = initialPageIndex;
    // Inisialisasi pages di dalam initState
    pages = [
      Dashboard(),
      const Layanan(),
      const Dokter(),
      const Riwayat(),
      const Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // bool isDesktop = constraints.maxWidth > 600;
        // bool isMobile = constraints.maxWidth <= 600;
        bool isTrackingPage = pageIndex == 2;

        return Scaffold(
            body: Center(
              child: pages[pageIndex],
            ),
            bottomNavigationBar: Stack(
              children: [
                Container(
                  height: 75,
                  // BUAT AGAR POJOK KANAN ATAS DAN POJOK KIRI ATAS MENJADI RONDED
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BottomIconWidget(
                        title: 'Layanan',
                        titleColor: pageIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        iconName: pageIndex == 1
                            ? Assets.icons.icSelectedLayanan.path
                            : Assets.icons.icUnselectedLayanan.path,
                        iconColor: pageIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        pageIndex: 1,
                        tap: () {
                          setState(() {
                            pageIndex = 1;
                          });
                        },
                      ),
                      BottomIconWidget(
                        title: 'Dokter',
                        titleColor: pageIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        iconName: pageIndex == 2
                            ? Assets.icons.icSelectedDoctor.path
                            : Assets.icons.icUnselectedDoctor.path,
                        iconColor: pageIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        pageIndex: 2,
                        tap: () {
                          setState(() {
                            pageIndex = 2;
                          });
                        },
                      ),
                      BottomIconWidget(
                        title: '',
                        titleColor: pageIndex == 0
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        iconName: pageIndex == 0
                            ? Assets.icons.icSelectedHome.path
                            : Assets.icons.icUnselectedHome.path,
                        iconColor: pageIndex == 0
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        pageIndex: 2,
                        tap: () {
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                      ),
                      BottomIconWidget(
                        title: 'Riwayat',
                        titleColor: pageIndex == 3
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        iconName: pageIndex == 3
                            ? Assets.icons.icSelectedHistory.path
                            : Assets.icons.icUnselectedHistory.path,
                        iconColor: pageIndex == 3
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        pageIndex: 3,
                        tap: () {
                          setState(() {
                            pageIndex = 3;
                          });
                        },
                      ),
                      BottomIconWidget(
                        title: 'Profil',
                        titleColor: pageIndex == 4
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        iconName: pageIndex == 4
                            ? Assets.icons.icSelectedUser.path
                            : Assets.icons.icUnselectedUser.path,
                        iconColor: pageIndex == 4
                            ? AppColors.primaryColor
                            : AppColors.gray,
                        pageIndex: 4,
                        tap: () {
                          setState(() {
                            pageIndex = 4;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // buat agar buttonnya seperti melayang
                Positioned(
                  bottom: 0, // Sesuaikan dengan kebutuhan Anda
                  left: 0,
                  right: 0,

                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionalTranslation(
                        translation: Offset(0, -0.5),
                        child: BottomIconWidget(
                          title: 'Home',
                          titleColor: pageIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.gray,
                          iconName: pageIndex == 0
                              ? Assets.icons.icSelectedHome.path
                              : Assets.icons.icUnselectedHome.path,
                          iconColor: pageIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.gray,
                          pageIndex: 0,
                          tap: () {
                            setState(() {
                              pageIndex = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ) // Jangan tampilkan bottomNavigationBar saat di Tracking Page
            );
      },
    );
  }
}
