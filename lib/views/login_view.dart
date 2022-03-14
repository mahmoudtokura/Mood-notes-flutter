import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:moodnotes/constants/routes.dart';
import 'package:moodnotes/utilities/show_error_dialog.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/auth_user.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          TextFormField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            child: const Text('Login'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                AuthUser? user = AuthService.firebase().currentUser;
                if (user != null && user.isEmailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (_) => false,
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                }
              } on UserNotFoundAuthException {
                showErrorDialog(
                  context,
                  "User not found",
                );
              } on WrongPasswordAuthException {
                showErrorDialog(
                  context,
                  "Incorrect user credentials",
                );
              } on WeakPasswordAuthException {
                showErrorDialog(
                  context,
                  "Weak password",
                );
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                  context,
                  "Email already in use",
                );
              } on InvalidEmailAuthException {
                showErrorDialog(
                  context,
                  "Email is invalid",
                );
              } on UserNotLoggedInException {
                showErrorDialog(
                  context,
                  "User not logged in",
                );
              } on GenericAuthException catch (e) {
                showErrorDialog(
                  context,
                  "Error: $e",
                );
              } catch (e) {
                await showErrorDialog(context, 'Error: ${e.toString()}');
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
