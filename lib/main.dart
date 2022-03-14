import 'package:flutter/material.dart';
import 'package:moodnotes/services/auth/auth_service.dart';
import 'package:moodnotes/services/auth/auth_user.dart';
import 'package:moodnotes/views/login_view.dart';
import 'package:moodnotes/views/notes_view.dart';
import 'package:moodnotes/views/register_view.dart';
import 'package:moodnotes/views/verify_email_view.dart';

import 'constants/routes.dart';
import 'enums/menu_action.dart';
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            AuthUser? user = AuthService.firebase().currentUser;
            if (user == null) {
              return const LoginView();
            } else if (user.isEmailVerified) {
              return const NotesView();
            } else {
              return const VerifyEmailView();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
