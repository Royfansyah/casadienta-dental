import 'package:casadienta_dental/pages/dashboard/dashboard.dart';
import 'package:casadienta_dental/pages/navbar/navbar.dart';
import 'package:casadienta_dental/pages/profile/components/tentang.dart';
import 'package:casadienta_dental/pages/login/register.dart';
import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/app_text_form_field.dart';
import 'services/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('Login berhasil');
      Navigator.pushReplacementNamed(context, '/navbar');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email tidak ditemukan.')),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password salah.')),
        );
      } else {
        print('Login error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Silahkan coba lagi, pastikan data sudah benar.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg_casadienta.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: const Column(
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
                    SizedBox(
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
                      height: 20,
                    ),
                    // ----------------------
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "Belum punya akun?",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodySmall
                          //       ?.copyWith(color: Colors.black),
                          // ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/register');
                            },
                            style: Theme.of(context).textButtonTheme.style,
                            child: Text(
                              'Daftar',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          loginUser();
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 15),
                    // ----------------------
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Atau',
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkResponse(
                                onTap: () =>
                                    AuthService.signInWithGoogle(context),
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Tentang Kami',
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
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tentang(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
              // ----------------------
              // ----------------------
            ],
          ),
        ),
      ),
    );
  }
}
