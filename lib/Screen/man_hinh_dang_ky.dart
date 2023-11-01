import 'dart:convert';

import 'package:app_dac_san/Model/tinh_thanh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class ManHinhDangKy extends StatefulWidget {
  ManHinhDangKy({
    super.key,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matKhauController = TextEditingController();
  final TextEditingController xacNhanMatKhauController =
      TextEditingController();
  final TextEditingController hoTenController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();

  @override
  _ManHinhDangKyState createState() => _ManHinhDangKyState();
}

class _ManHinhDangKyState extends State<ManHinhDangKy> {
  List<TinhThanh> dsTT = [];
  bool isNam = true;
  bool hidePassword = true;

  @override
  void initState() {
    xeemTinhThanh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<TinhThanh>> dsLabelTinhThanh = [];
    for (var tinhThanh in dsTT) {
      dsLabelTinhThanh.add(
        DropdownMenuEntry<TinhThanh>(label: tinhThanh.ten!, value: tinhThanh),
      );
    }

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
                  labelText: "Email",
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
                controller: widget.matKhauController,
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
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.xacNhanMatKhauController,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
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
                  } else if (value != widget.matKhauController.text) {
                    return "Mật khẩu vừa nhập không trùng khớp";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                controller: widget.hoTenController,
                decoration: const InputDecoration(
                  labelText: "Họ tên",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập họ tên";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                controller: widget.sdtController,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập số điện thoại";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              VerticalGapSizedBox(),
              Flexible(
                flex: 1,
                child: DropdownMenu(
                  dropdownMenuEntries: dsLabelTinhThanh,
                  hintText: "Danh sách tỉnh thành",
                ),
              ),
              VerticalGapSizedBox(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListTile(
                      title: const Text("Nam"),
                      leading: Radio(
                        value: true,
                        groupValue: isNam,
                        onChanged: (bool? value) {
                          setState(() {
                            isNam = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: const Text("Nữ"),
                      leading: Radio(
                        value: false,
                        groupValue: isNam,
                        onChanged: (bool? value) {
                          setState(() {
                            isNam = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              VerticalGapSizedBox(),
              OutlinedButton(
                  style: MaxWidthRoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        User? user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.matKhauController.text,
                        ))
                            .user;

                        if (user != null && context.mounted) {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: widget.emailController.text,
                                  password: widget.matKhauController.text)
                              .whenComplete(
                                () => context.go("/"),
                              );
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

  Future<void> xeemTinhThanh() async {
    var reponse =
        await get(Uri.parse('https://provinces.open-api.vn/api/?depth=1'));
    var result = json.decode(utf8.decode(reponse.bodyBytes));

    for (var document in result) {
      TinhThanh tinhThanh = TinhThanh.fromJson(document);
      dsTT.add(tinhThanh);
    }

    setState(() {});
  }
}
