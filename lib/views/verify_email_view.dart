import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Send email verification"),
        ElevatedButton(
          child: const Text("Send verification email"),
          onPressed: () async {
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          },
        ),
        ElevatedButton(
          child: const Text("Sign out"),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}
