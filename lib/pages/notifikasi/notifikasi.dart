import 'package:flutter/material.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<Notifikasi> notifikasi = [];

  @override
  void initState() {
    super.initState();
    _configureOneSignal();
    _loadNotifikasi();
  }

  Future<void> _loadNotifikasi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notifikasiJson = prefs.getString('notifikasi');
    if (notifikasiJson != null) {
      final List<dynamic> decodedList = json.decode(notifikasiJson);
      setState(() {
        notifikasi = decodedList
            .map((jsonItem) => Notifikasi(
                  title: jsonItem['title'],
                  message: jsonItem['message'],
                  date: DateTime.parse(jsonItem['date']),
                ))
            .toList();
      });
    }
  }

  Future<void> _saveNotifikasi() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = notifikasi
        .map((notif) => {
              'title': notif.title,
              'message': notif.message,
              'date': notif.date.toIso8601String(),
            })
        .toList();
    await prefs.setString('notifikasi', json.encode(jsonList));
  }

  Future<void> _refreshNotifikasi() async {
    await _loadNotifikasi(); // Refresh data notifikasi
  }

  void _configureOneSignal() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) async {
        final notification = event.notification;
        await _loadNotifikasi(); // Load existing notifications
        setState(() {
          notifikasi.add(
            Notifikasi(
              title: notification.title ?? 'No Title',
              message: notification.body ?? 'No Message',
              date: DateTime.now(),
            ),
          );
          _saveNotifikasi();
        });
      },
    );

    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) async {
        final notification = result.notification;
        await _loadNotifikasi(); // Load existing notifications
        setState(() {
          notifikasi.add(
            Notifikasi(
              title: notification.title ?? 'No Title',
              message: notification.body ?? 'No Message',
              date: DateTime.now(),
            ),
          );
          _saveNotifikasi();
        });
      },
    );
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshNotifikasi,
        child: ListView.builder(
          itemCount: notifikasi.length,
          itemBuilder: (context, index) {
            final notif = notifikasi[index];
            return Dismissible(
              key:
                  Key(notif.date.toIso8601String()), // Unique key for each item
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  notifikasi.removeAt(index);
                  _saveNotifikasi();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifikasi dihapus')),
                );
              },
              background: Container(color: Colors.red),
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text(notif.title),
                subtitle: Text(
                  notif.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing:
                    Text(DateFormat('dd/MM/yyyy HH:mm').format(notif.date)),
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
                              'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(notif.date)}',
                            ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
