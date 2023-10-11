import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class UserPage extends StatefulWidget {
  UserPage({
    super.key,
    required this.auth,
    required this.notifyParent,
  });

  final Function() notifyParent;
  final FirebaseAuth auth;
  final TextEditingController emailController = TextEditingController();

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    widget.emailController.text = widget.auth.currentUser!.uid;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    child: const Text("Đăng xuất"),
                    onPressed: () {
                      widget.auth.signOut();
                      widget.notifyParent();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
