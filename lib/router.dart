import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_inventory_management/src/dashboard/dashboard_screen.dart';
import 'package:pharmacy_inventory_management/src/settings/settings_controller.dart';
import 'package:pharmacy_inventory_management/src/settings/settings_view.dart';
import 'package:provider/provider.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const DashboardScreen(),
    routes: [
      GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              sideBuilder: (context, constraints) => Container(width: 100, height: 100, color: Colors.red),
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
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
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
            );
          },
          routes: [
            GoRoute(
                path: 'forgot-password',
                builder: (context, state) {
                  final arguments = state.uri.queryParameters;
                  return ForgotPasswordScreen(
                    email: arguments['email'],
                    headerMaxExtent: 200,
                  );
                })
          ]),
      GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(providers: const [], actions: [
              SignedOutAction((context) {
                context.pushReplacement('/');
              })
            ]);
          }),
      GoRoute(
        path: 'settings',
        builder: (context, state) {
          final settingsController = context.read<SettingsController>();
          return SettingsView(controller: settingsController);
        },
      )
    ],
  ),
]);
