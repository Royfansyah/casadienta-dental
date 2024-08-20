import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import '/components/app_text_form_field.dart';
import 'package:casadienta_dental/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Kirim data pengguna ke API
      final response = await http.post(
        Uri.parse('https://casadienta-92546be972aa.herokuapp.com/api/User'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id_google': userCredential.user?.uid ?? '',
          'nama_user': usernameController.text,
          'email': emailController.text,
          'role': 'pengunjung',
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Menampilkan SnackBar untuk registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil')),
        );
        // Jika berhasil, Anda bisa menavigasi pengguna ke halaman login atau menampilkan pesan sukses
        print('Registrasi berhasil');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Jika gagal, Anda bisa menampilkan pesan error
        print('Registrasi gagal, silahkan coba lagi.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal, silahkan coba lagi.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Kata sandi terlalu lemah.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kata sandi terlalu lemah')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('Email sudah digunakan.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sudah digunakan')),
        );
      } else {
        print('Registrasi gagal, silahkan coba lagi.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal, silahkan coba lagi.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal, silahkan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Akun',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
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
                      'Daftarkan Akunmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Daftar untuk mengakses semua layanan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextFormField(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      controller: emailController,
                    ),
                    AppTextFormField(
                      labelText: 'Nama Lengkap',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      controller: usernameController,
                    ),
                    AppTextFormField(
                      labelText: 'Password',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      controller: passwordController,
                      obscureText: true, // Menambahkan properti ini
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // RichText(
                          //   text: TextSpan(
                          //     text: "By signing up, you agree to our ",
                          //     style: const TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 13,
                          //     ),
                          //     children: [
                          //       TextSpan(
                          //         recognizer: TapGestureRecognizer()
                          //           ..onTap = () {
                          //             print("klik Term & Condition");
                          //           },
                          //         text: "Term & Condition",
                          //         style: const TextStyle(
                          //           color: Colors.red,
                          //         ),
                          //       ),
                          //       const TextSpan(
                          //         text: " and ",
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       TextSpan(
                          //         recognizer: TapGestureRecognizer()
                          //           ..onTap = () {
                          //             print("klik Policies");
                          //           },
                          //         text: "Policies",
                          //         style: const TextStyle(
                          //           color: Colors.red,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                registerUser();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              textStyle:
                                  MaterialStateProperty.all(const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              )),
                              fixedSize:
                                  MaterialStateProperty.all(Size(500, 35)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                              ),
                            ),
                            child: Text('Daftar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: Theme.of(context).textButtonTheme.style,
                      child: Text(
                        'Login Disini',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
