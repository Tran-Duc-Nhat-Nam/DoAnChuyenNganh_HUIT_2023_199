import 'dart:convert';

import 'package:app_dac_san/Model/tinh_thanh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import '../Service/thu_vien_chung.dart';

class ManHinhDangKy extends StatefulWidget {
  ManHinhDangKy({
    super.key,
    this.email,
  });
  String? email;
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
  String? tinhThanh;
  bool isFixed = false;

  @override
  void initState() {
    xemTinhThanh();

    if (widget.email != null) {
      widget.emailController.text = widget.email!;
      isFixed = true;
    }

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
      resizeToAvoidBottomInset: false,
      body: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                readOnly: isFixed,
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
                enabled: !isFixed,
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.matKhauController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  labelText: "Mật khẩu",
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
                  if (isFixed) {
                    return null;
                  } else if (value!.isEmpty) {
                    return "Vui lòng nhập tài khoản";
                  }
                  return null;
                },
              ),
              VerticalGapSizedBox(),
              TextFormField(
                enabled: !isFixed,
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: widget.xacNhanMatKhauController,
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
                  if (isFixed) {
                    return null;
                  } else if (value!.isEmpty) {
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
                decoration: RoundInputDecoration("Họ tên"),
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
                decoration: RoundInputDecoration("Số điện thoại"),
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
              DropdownMenu(
                width: MediaQuery.of(context).size.width - 30,
                dropdownMenuEntries: dsLabelTinhThanh,
                hintText: "Danh sách tỉnh thành",
                onSelected: (value) {
                  tinhThanh = value!.ten;
                },
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
                        if (isFixed) {
                          await addUser(
                            widget.emailController.text,
                            widget.hoTenController.text,
                            isNam,
                            tinhThanh!,
                          );
                          if (context.mounted) {
                            context.go("/");
                          }
                        } else {
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
                                .then(
                              (value) async {
                                await addUser(
                                  widget.emailController.text,
                                  widget.hoTenController.text,
                                  isNam,
                                  tinhThanh!,
                                );
                                if (context.mounted) {
                                  context.go("/");
                                }
                              },
                            );
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

  Future<void> xemTinhThanh() async {
    var reponse = await get(Uri.parse(
        'https://cntt199.000webhostapp.com/getTinhThanh.php')); //https://cntt199.000webhostapp.com/getTinhThanh.php //https://provinces.open-api.vn/api/?depth=1
    var result = json.decode(utf8.decode(reponse.bodyBytes));

    for (var document in result) {
      TinhThanh tinhThanh = TinhThanh.fromJson(document);
      dsTT.add(tinhThanh);
    }
    setState(() {});
  }

  Future<void> addUser(String uid) async {
    Map<String, dynamic> data = {
      // 'uid': uid,
      'email': widget.emailController.text,
      'hoten': widget.hoTenController.text,
      'gioitinh': isNam ? "Nam" : "Nữ",
      'diachi': tinhThanh,
    };

    var url = Uri.parse('https://cntt199.000webhostapp.com/registerUser.php');
    await http.post(url, body: data);
  }
}
