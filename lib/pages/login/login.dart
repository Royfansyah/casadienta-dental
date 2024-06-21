import 'package:casadienta_dental/pages/dashboard/dashboard.dart';
import 'package:casadienta_dental/pages/navbar/navbar.dart';
import 'package:casadienta_dental/pages/profile/components/tentang.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/app_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg_casadienta.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black
                          .withOpacity(0.5), // Ganti nilai 0.5 sesuai kebutuhan
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selalu Jaga Kesehatan Gigimu\nBersama Casadienta Dental',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Silahkan Login Menggunakan Akunmu',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            'Login with',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 3, // Tinggi shadow
                            borderRadius: BorderRadius.circular(15.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkResponse(
                                onTap: () =>
                                    // AuthService.signInWithGoogle(context),
                                    {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NavBar(initialPageIndex: 0),
                                    ),
                                  ),
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/google.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 7),
                                      const Text(
                                        'Google',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            'This Is Us',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tentang(),
                          ),
                        );
                        // Tambahkan logika untuk tombol login di sini
                      },
                      // onTap: () async {
                      //   try {
                      //     // Contoh untuk login sebagai tamu
                      //     UserCredential user =
                      //         await FirebaseAuth.instance.signInAnonymously();
                      //     // Navigate to the Tentang page after successful login
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => Tentang(),
                      //       ),
                      //     );
                      //   } catch (e) {
                      //     // Handle error
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(e.toString())),
                      //     );
                      //   }
                      // },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(13.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/img/logo_casadienta.jpg',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         "Don't have an account?",
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodySmall
              //             ?.copyWith(color: Colors.black),
              //       ),
              //       TextButton(
              //         onPressed: () {
              //           Navigator.pushReplacementNamed(context, 'register');
              //           // Tambahkan logika untuk tombol login di sini
              //         },
              //         style: Theme.of(context).textButtonTheme.style,
              //         child: Text(
              //           'Register Here',
              //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //                 color: Colors.blue,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
