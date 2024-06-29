import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_inventory_management/src/auth/custom_sign_in_screen.dart';
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
        builder: (context, state) => const CustomSignInScreen(),
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
        ],
      ),
      GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) {
            return ProfileScreen(providers: const [], actions: [
              SignedOutAction((context) {
                context.pushReplacement('/');
              })
            ]);
          }),
      GoRoute(
        path: 'settings',
        name: 'settings',
        builder: (context, state) {
          final settingsController = context.read<SettingsController>();
          return SettingsView(controller: settingsController);
        },
      )
    ],
  ),
]);
