import 'package:flutter/material.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:intl/intl.dart';

class Notifikasi {
  final String title;
  final String message;
  final DateTime date;

  Notifikasi({
    required this.title,
    required this.message,
    required this.date,
  });
}

class NotifikasiPage extends StatelessWidget {
  final List<Notifikasi> notifikasi = [
    Notifikasi(
      title: 'Pesan Baru',
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      date: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Notifikasi(
      title: 'Update Tersedia',
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        centerTitle: true,
        title: Text(
          'Notifikasi',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: ListView.builder(
        itemCount: notifikasi.length,
        itemBuilder: (context, index) {
          final notif = notifikasi[index];
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notif.title),
            subtitle: Text(
              notif.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(DateFormat('dd/MM/yyyy HH:mm').format(notif.date)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(notif.title),
                    backgroundColor: AppColors.backGroundColor,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Message: ${notif.message}'),
                        SizedBox(height: 10),
                        Text(
                            'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(notif.date)}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/notifications': (context) => NotifikasiPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
          child: Text('Go to Notifications'),
        ),
      ),
    );
  }
}
