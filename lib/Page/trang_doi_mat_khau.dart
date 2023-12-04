import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Service/thu_vien_style.dart';
import '../Widget/VerticalGapSizedBox.dart';

class TrangDoiMatKhau extends StatefulWidget {
  TrangDoiMatKhau({super.key, required this.uid});
  final String? uid;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matKhauCuController = TextEditingController();
  final TextEditingController matKhauMoiController = TextEditingController();
  final TextEditingController matKhauMoiXacNhanController =
      TextEditingController();
  @override
  _TrangDoiMatKhauState createState() => _TrangDoiMatKhauState();
}

class _TrangDoiMatKhauState extends State<TrangDoiMatKhau> {
  bool hidePassword = false;
  @override
  Widget build(BuildContext context) {
    if (widget.uid != null) {
      widget.emailController.text = FirebaseAuth.instance.currentUser!.email!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                enabled: widget.uid != null,
                controller: widget.emailController,
                decoration: RoundInputDecoration("Email"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập email";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.matKhauCuController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  labelText: "Mật khẩu hiện tại",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
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
                    return "Vui lòng nhập mật khẩu";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.matKhauMoiController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  labelText: "Mật khẩu mới",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
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
                    return "Vui lòng nhập mật khẩu";
                  } else if (value == widget.matKhauCuController.text) {
                    return "Mật khẩu mới không được trùng với mật khẩu cũ";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.matKhauMoiXacNhanController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  labelText: "Nhập lại mật khẩu",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
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
                    return "Vui lòng nhập mật khẩu";
                  } else if (value != widget.matKhauMoiController.text) {
                    return "Mật khẩu vừa nhập không trùng khớp";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              OutlinedButton(
                  style: RoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          doiMatKhau(user, context);
                        } else {
                          user = (await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                            email: widget.emailController.text,
                            password: widget.matKhauCuController.text,
                          ))
                              .user;

                          if (user != null && context.mounted) {
                            doiMatKhau(user, context);
                          }
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
                  child: const Text("Đăng ký")),
            ],
          ),
        ),
      ),
    );
  }

  void doiMatKhau(User user, BuildContext context) {
    user.updatePassword(widget.matKhauMoiController.text).then((_) {
      context.go("/nguoidung");
    }).catchError((error) {
      var snackBar = SnackBar(
        content: Text(error.toString()),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
