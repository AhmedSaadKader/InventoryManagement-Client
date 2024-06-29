import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSignInScreen extends StatelessWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SignInScreen(
        actions: [
          ForgotPasswordAction(((context, email) {
            final uri = Uri(
              path: '/sign-in/forgot-password',
              queryParameters: <String, String?>{
                'email': email,
              },
            );
            context.push(uri.toString());
          })),
          AuthStateChangeAction(((context, state) {
            final user = state is SignedIn
                ? state.user
                : state is UserCreated
                    ? state.credential.user
                    : null;
            if (user == null) {
              return;
            }
            if (state is UserCreated) {
              user.updateDisplayName(user.email!.split('@')[0]);
            }
            if (!user.emailVerified) {
              user.sendEmailVerification();
              const snackBar = SnackBar(content: Text('Please check your email to verify your email'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            context.pushReplacement('/');
          })),
        ],
        styles: const {
          EmailFormStyle(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          )
        },
        headerBuilder: (context, constraints, _) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome to the Pharmacy Inventory Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
