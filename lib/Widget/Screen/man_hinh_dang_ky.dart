// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vina_foods/Model/nguoi_dung.dart';
import 'package:vina_foods/Service/them_nguoi_dung.dart';

import '../../Model/tinh_thanh.dart';
import '../../Service/thu_vien_style.dart';
import '../../Widget/khoang_trong_doc.dart';
import 'man_hinh_cho_xac_nhan.dart';

class ManHinhDangKy extends StatefulWidget {
  ManHinhDangKy({
    super.key,
    this.uid,
    this.email,
  });
  final String? uid;
  final String? email;
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
  bool isPasswordReadOnly = false;
  bool isEmailReadOnly = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    xemTinhThanh();

    if (widget.uid != null) {
      isPasswordReadOnly = true;
    }
    if (widget.email != null) {
      widget.emailController.text = widget.email!;
      isEmailReadOnly = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dsLabelTinhThanh = [];
    for (var tinhThanh in dsTT) {
      dsLabelTinhThanh.add(
        tinhThanh.ten,
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
              Container(
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  "ĐĂNG KÝ",
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              TextFormField(
                enabled: !isEmailReadOnly,
                controller: widget.emailController,
                decoration: RoundInputDecoration("Email"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập email";
                  }
                  return null;
                },
              ),
              KhoangTrongDoc(),
              textFormFieldMatKhau(context),
              KhoangTrongDoc(),
              textFormFieldNhapLaiMatKhau(context),
              KhoangTrongDoc(),
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
              KhoangTrongDoc(),
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
              KhoangTrongDoc(),
              DateTimeField(
                decoration: RoundInputDecoration("Ngày sinh"),
                format: DateFormat("dd/MM/yyyy"),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      selectedDate = value;
                      print(selectedDate.toString());
                    }
                  });
                },
              ),
              KhoangTrongDoc(),
              DropdownSearch<TinhThanh>(
                validator: (value) {
                  if (value == null) {
                    return "Vui lòng chọn tỉnh thành";
                  }
                  return null;
                },
                popupProps: const PopupProps.menu(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "Danh sách tỉnh thành",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  showSelectedItems: true,
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    label: const Text("Tỉnh thành"),
                    contentPadding: const EdgeInsetsDirectional.only(
                      start: 25,
                      top: 15,
                      bottom: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
                compareFn: (item1, item2) {
                  return item1 == item2;
                },
                onChanged: (value) {
                  if (value != null) {
                    tinhThanh = value.ten;
                  }
                },
                items: dsTT,
                itemAsString: (value) {
                  return value.ten;
                },
              ),
              KhoangTrongDoc(),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
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
                    fit: FlexFit.tight,
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
              KhoangTrongDoc(),
              OutlinedButton(
                  style: MaxWidthRoundButtonStyle(),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        if (isPasswordReadOnly) {
                          await FirebaseAuth.instance.currentUser!
                              .updateEmail(widget.emailController.text)
                              .whenComplete(() async {
                            await themNguoiDung(NguoiDung(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              email: widget.emailController.text,
                              hoTen: widget.hoTenController.text,
                              isNam: isNam,
                              diaChi: tinhThanh!,
                              soDienThoai: widget.sdtController.text,
                              ngaySinh: selectedDate,
                            ));
                            if (context.mounted) {
                              context.go("/");
                            }
                          });
                        } else {
                          User? user = (await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                            email: widget.emailController.text,
                            password: widget.matKhauController.text,
                          ))
                              .user;

                          if (user != null) {
                            user.sendEmailVerification();
                            FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: widget.emailController.text,
                              password: widget.matKhauController.text,
                            );
                            await themNguoiDung(NguoiDung(
                              uid: user.uid,
                              email: widget.emailController.text,
                              hoTen: widget.hoTenController.text,
                              isNam: isNam,
                              diaChi: tinhThanh!,
                              soDienThoai: widget.sdtController.text,
                              ngaySinh: selectedDate,
                            ));
                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManHinhChoXacNhan(
                                      user: user,
                                    ),
                                  ));
                            }
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

  TextFormField textFormFieldNhapLaiMatKhau(BuildContext context) {
    return TextFormField(
      enabled: !isPasswordReadOnly,
      obscureText: hidePassword,
      enableSuggestions: false,
      autocorrect: false,
      controller: widget.xacNhanMatKhauController,
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
        if (isPasswordReadOnly) {
          return null;
        } else if (value!.isEmpty) {
          return "Vui lòng nhập mật khẩu";
        } else if (value != widget.matKhauController.text) {
          return "Mật khẩu vừa nhập không trùng khớp";
        }
        return null;
      },
    );
  }

  TextFormField textFormFieldMatKhau(BuildContext context) {
    return TextFormField(
      enabled: !isPasswordReadOnly,
      obscureText: hidePassword,
      enableSuggestions: false,
      autocorrect: false,
      controller: widget.matKhauController,
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
        if (isPasswordReadOnly) {
          return null;
        } else if (value!.isEmpty) {
          return "Vui lòng nhập mật khẩu";
        }
        return null;
      },
    );
  }

  SizedBox HorizontalGapSizedBox() {
    return const SizedBox(
      width: 15,
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
}
