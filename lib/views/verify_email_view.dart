import 'package:flutter/material.dart';
import 'package:moodnotes/constants/routes.dart';

import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "We have sent you and email verification link. Please check your email and verify your account tp proceed.",
              ),
              const SizedBox(height: 20),
              const Text("resend email verification link"),
              ElevatedButton(
                child: const Text("Send verification email"),
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
              ),
              ElevatedButton(
                child: const Text("Restart process"),
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushReplacementNamed(
                    registerRoute,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
