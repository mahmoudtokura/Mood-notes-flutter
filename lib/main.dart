import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moodnotes/views/login_view.dart';
import 'package:moodnotes/views/register_view.dart';
import 'package:moodnotes/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const LoginView();
            } else if (user.emailVerified) {
              return const Text("Done");
            } else {
              return const VerifyEmailView();
            }
          // FirebaseAuth.instance.authStateChanges().listen(
          //   (User? user) {
          //     if (user == null) {
          //       return const LoginView();
          //     } else if (user.emailVerified) {
          //       return const Text("Done");
          //     } else {
          //       return const VerifyEmailView();
          //     }
          //   },
          // );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}