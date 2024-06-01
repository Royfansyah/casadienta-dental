import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class Tentang extends StatefulWidget {
  const Tentang({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TentangState createState() => _TentangState();
}

class _TentangState extends State<Tentang> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardC = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardD = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardE = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: Text(
          widget.title ?? 'Tentang',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              baseColor: AppColors.backGroundColor,
              key: cardA,
              expandedTextColor: AppColors.primaryColor,
              title: const Text(
                'Tentang Kami',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Deskripsi Tentang Kami',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              baseColor: AppColors.backGroundColor,
              key: cardB,
              expandedTextColor: AppColors.primaryColor,
              title: const Text(
                'Riwayat Perusahaan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Deskripsi Riwayat Perusahaan',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              baseColor: AppColors.backGroundColor,
              key: cardC,
              expandedTextColor: AppColors.primaryColor,
              title: const Text(
                'Info Kontak',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """Alamat: 

Email: 

Telepon: """,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              baseColor: AppColors.backGroundColor,
              key: cardD,
              expandedTextColor: AppColors.primaryColor,
              title: const Text(
                'Tim Pengembang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """Kami adalah mahasiswa Semester 6 dari Kampus Universitas Catur Insan Cendekia Kota Cirebon.

Anggota :
- 20210120068 - Ega Permana
- 20210120071 - Royfansyah M Razavi""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              baseColor: AppColors.backGroundColor,
              key: cardE,
              expandedTextColor: AppColors.primaryColor,
              title: const Text(
                'Versi Aplikasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """Versi Aplikasi : x.x.x

Terakhir Diperbarui : d/m/y""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
