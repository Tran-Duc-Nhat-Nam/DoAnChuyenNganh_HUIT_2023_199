// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../../Model/nguoi_dung.dart';
import '../../Service/thu_vien_style.dart';
import '../../Widget/khoang_trong_doc.dart';
import '../../Widget/khoang_trong_ngang.dart';
import '../snackbar_firebase_auth.dart';
import 'man_hinh_dang_ky.dart';

class ManHinhDangNhap extends StatefulWidget {
  ManHinhDangNhap({
    super.key,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_pho.png",
                height: 180,
              ),
              Container(
                height: 125,
                alignment: Alignment.center,
                child: Text(
                  "ĐĂNG NHẬP",
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              TextFormField(
                controller: widget.emailController,
                decoration: RoundInputDecoration("Tài khoản"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập tài khoản";
                  }
                  return null;
                },
              ),
              KhoangTrongDoc(),
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.passwordController,
                decoration: RoundPasswordInputDecoration("Mật khẩu", context),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập mật khẩu";
                  }
                  return null;
                },
                onFieldSubmitted: (value) async {
                  if (widget.formKey.currentState!.validate()) {
                    try {
                      User? user = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                        email: widget.emailController.text,
                        password: widget.passwordController.text,
                      ))
                          .user;

                      if (user != null && context.mounted) {
                        context.go("/dacsan");
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarFirebaseAuth(e));
                      }
                    }
                  }
                },
              ),
              KhoangTrongDoc(),
              KhoangTrongDoc(),
              KhoangTrongDoc(),
              ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue),
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(25)),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                      left: 35,
                      right: 35,
                    )),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        User? user = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                        ))
                            .user;

                        if (user != null && context.mounted) {
                          context.go("/");
                        }
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarFirebaseAuth(e));
                        }
                      }
                    }
                  },
                  child: const Text("Đăng nhập")),
              KhoangTrongDoc(),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(35),
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: const BorderSide(
                        width: 1, color: Colors.lightBlueAccent),
                  ),
                  onPressed: () => context.go("/signup"),
                  child: const Text("Đăng ký")),
              KhoangTrongDoc(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    style: ButtonStyle(
                        maximumSize:
                            MaterialStateProperty.all(const Size(56, 56))),
                    onPressed: DangNhapGoogle,
                    icon: Image.asset("assets/images/google.png"),
                  ),
                  KhoangTrongNgang(),
                  IconButton(
                    style: ButtonStyle(
                        maximumSize:
                            MaterialStateProperty.all(const Size(56, 56))),
                    onPressed: DangNhapFacebook,
                    icon: Image.asset("assets/images/facebook.png"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration RoundPasswordInputDecoration(
      String text, BuildContext context) {
    return InputDecoration(
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      labelText: text,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(35),
        ),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          // Based on passwordVisible state choose the icon
          hidePassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
      ),
    );
  }

  void DangNhapGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else if (Platform.isAndroid) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await DangKyThemThongTin(user);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng nhập thất bại"),
          ),
        );
      }
    }
  }

  void DangNhapFacebook() async {
    if (kIsWeb) {
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      await FirebaseAuth.instance.signInWithPopup(facebookProvider);
    } else {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await DangKyThemThongTin(user);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng nhập thất bại"),
          ),
        );
      }
    }
  }

  Future<void> DangKyThemThongTin(User user) async {
    List<NguoiDung> dsNguoiDung = [];

    var response = await get(Uri.parse(
        'https://cntt199.000webhostapp.com/getNguoiDung.php')); //https://cntt199.000webhostapp.com/getTinhThanh.php //https://provinces.open-api.vn/api/?depth=1
    var result = json.decode(utf8.decode(response.bodyBytes));

    if (context.mounted) {
      for (var document in result) {
        NguoiDung nguoiDung = NguoiDung.fromJson(document);
        dsNguoiDung.add(nguoiDung);
      }

      for (var nd in dsNguoiDung) {
        if (nd.uid == user.uid) {
          context.go("/");
          return;
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManHinhDangKy(
              uid: user.uid,
              email: user.email,
            ),
          ));
    }
  }
}
