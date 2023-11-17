import 'dart:convert';
import 'dart:io';

import 'package:app_dac_san/Model/nguoi_dung.dart';
import 'package:app_dac_san/Screen/man_hinh_dang_ky.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../Service/thu_vien_chung.dart';

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
              Image.asset("images/adsvn-low-resolution-logo-transparent.png"),
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
              VerticalGapSizedBox(),
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
                    } on Exception catch (e) {
                      var snackBar = SnackBar(
                        content: Text(e.toString()),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  }
                },
              ),
              VerticalGapSizedBox(),
              VerticalGapSizedBox(),
              VerticalGapSizedBox(),
              ElevatedButton(
                  style: MaxWidthRoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        // DangNhapMySql();
                        User? user = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                        ))
                            .user;

                        if (user != null && context.mounted) {
                          context.go("/");
                        }
                      } on Exception catch (e) {
                        var snackBar = SnackBar(
                          content: Text(e.toString()),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }
                  },
                  child: const Text("Đăng nhập")),
              VerticalGapSizedBox(),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(35),
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    side: BorderSide(width: 1, color: Colors.lightBlueAccent),
                  ),
                  onPressed: () => context.go("/signup"),
                  child: const Text("Đăng ký")),
              VerticalGapSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    style: RoundButtonStyle(),
                    onPressed: DangNhapGoogle,
                    icon: loadHinh("images/google.png"),
                  ),
                  HorizontalGapSizedBox(),
                  IconButton(
                    style: RoundButtonStyle(),
                    onPressed: DangNhapFacebook,
                    icon: loadHinh("images/facebook.png"),
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
      fillColor: const Color.fromARGB(255, 16, 16, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
      List<NguoiDung> dsNguoiDung = [];

      var reponse = await get(Uri.parse(
          'https://cntt199.000webhostapp.com/getNguoiDung.php')); //https://cntt199.000webhostapp.com/getTinhThanh.php //https://provinces.open-api.vn/api/?depth=1
      var result = json.decode(utf8.decode(reponse.bodyBytes));

      if (context.mounted) {
        for (var document in result) {
          NguoiDung nguoiDung = NguoiDung.fromJson(document);
          dsNguoiDung.add(nguoiDung);
        }

        for (var nd in dsNguoiDung) {
          if (nd.email == user.email) {
            context.go("/");
            return;
          }
        }

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManHinhDangKy(
                email: user.email,
              ),
            ));
      }
    }
  }

  void DangNhapFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    if (FirebaseAuth.instance.currentUser != null && context.mounted) {
      context.go("/");
    }
  }

  SizedBox HorizontalGapSizedBox() {
    return const SizedBox(
      width: 15,
    );
  }

  SizedBox VerticalGapSizedBox() {
    return const SizedBox(
      height: 15,
    );
  }

  ButtonStyle MaxWidthRoundButtonStyle() {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(25)),
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
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
