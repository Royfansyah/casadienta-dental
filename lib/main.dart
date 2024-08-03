import 'package:casadienta_dental/pages/dashboard/dashboard.dart';
import 'package:casadienta_dental/pages/login/login.dart';
import 'package:casadienta_dental/pages/splash_screen/splash_screen.dart';
// import 'package:casadienta_dental/pages/navbar/navbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casadienta_dental/pages/login/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);                                

  OneSignal.shared.setAppId("ac7b446d-c82e-4064-a25c-4951aa8e0191");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  // menampilkan garis debug
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Dashboard(),
      },
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({Key? key}) : super(key: key);

  @override
  State<MyAppBody> createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<MyAppBody> {
  @override
  void initState() {
    super.initState();
    // Cek status otentikasi saat aplikasi dimulai
    checkAuthentication();
  }

  // Fungsi untuk memeriksa status otentikasi pengguna
  void checkAuthentication() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user = auth.currentUser;

    // await Future.delayed(const Duration(seconds: 1)); // Jika Anda masih ingin menambahkan penundaan

    // if (user != null) {
    // Jika sudah login, arahkan ke halaman dashboard atau navbar sesuai kebutuhan
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => NavBar(initialPageIndex: 0),
    //   ),
    // );
    // } else {
    // Jika belum login, arahkan ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget saat memeriksa status otentikasi
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
