import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
    required this.notifyParent,
    required this.auth,
  });

  final Function() notifyParent;
  final FirebaseAuth auth;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: widget.emailController,
                decoration: const InputDecoration(
                  labelText: "Tài khoản",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
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
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      hidePassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập tài khoản";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              ElevatedButton(
                  style: MaxWidthRoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        User? user =
                            (await widget.auth.signInWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                        ))
                                .user;

                        if (user != null) {
                          widget.notifyParent();
                        }
                      } on Exception catch (e) {
                        var snackBar = SnackBar(
                          content: Text(e.toString()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: const Text("Đăng nhập")),
              VerticalGapSizedBox(),
              OutlinedButton(
                  style: MaxWidthRoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        User? user =
                            (await widget.auth.createUserWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                        ))
                                .user;

                        if (user != null) {
                          widget.auth.signInWithEmailAndPassword(
                              email: widget.emailController.text,
                              password: widget.passwordController.text);
                          widget.notifyParent();
                        }
                      } on Exception catch (e) {
                        var snackBar = SnackBar(
                          content: Text(e.toString()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: const Text("Đăng ký")),
              VerticalGapSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: RoundButtonStyle(),
                      onPressed: () async {
                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        // Obtain the auth details from the request
                        final GoogleSignInAuthentication? googleAuth =
                            await googleUser?.authentication;

                        // Create a new credential
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth?.accessToken,
                          idToken: googleAuth?.idToken,
                        );

                        // Once signed in, return the UserCredential
                        await widget.auth.signInWithCredential(credential);

                        if (widget.auth.currentUser != null) {
                          widget.notifyParent();
                        }
                      },
                      child: const Text("Gmail")),
                  HorizontalGapSizedBox(),
                  ElevatedButton(
                      style: RoundButtonStyle(),
                      onPressed: () {},
                      child: const Text("Facebook")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle RoundButtonStyle() {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: MaterialStateProperty.all(const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 30,
        right: 30,
      )),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
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
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: MaterialStateProperty.all(const EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 30,
        right: 30,
      )),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
