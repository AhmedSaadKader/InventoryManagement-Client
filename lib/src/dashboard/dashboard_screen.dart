import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_inventory_management/src/app_state.dart';
import 'package:pharmacy_inventory_management/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final appState = context.watch<ApplicationState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: const Icon(Icons.notifications)),
          IconButton(
              onPressed: () {
                context.push('/settings', extra: settingsController);
              },
              icon: const Icon(Icons.settings)),
          appState.loggedIn
              ? PopupMenuButton(
                  tooltip: "Account options",
                  position: PopupMenuPosition.under,
                  icon: CircleAvatar(),
                  onSelected: (choice) async {
                    if (choice == 'logout') {
                      await FirebaseAuth.instance.signOut();
                    } else if (choice == 'profile') {
                      context.push('/profile');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: Text('Profile'),
                        value: 'profile',
                      ),
                      const PopupMenuItem(
                        child: Text('Logout'),
                        value: 'logout',
                      )
                    ];
                  },
                )
              : ElevatedButton(
                  onPressed: () => context.push('/sign-in'),
                  child: Text('Sign in'),
                )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: BuildMetricCard(title: 'Low Stock', value: '26', color: Colors.red)),
                SizedBox(width: 16.0),
                Expanded(child: BuildMetricCard(title: 'Orders Due', value: '3', color: Colors.green))
              ],
            ),
            SizedBox(height: 16.0),
            BuildQuickActions(),
            SizedBox(height: 16.0),
            Expanded(child: BuildRecentActivity()),
          ],
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}

class BuildMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const BuildMetricCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class BuildQuickActions extends StatelessWidget {
  const BuildQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildQuickActionButton(icon: Icons.add, label: 'Stock Count'),
        BuildQuickActionButton(icon: Icons.create, label: 'New Order'),
        BuildQuickActionButton(icon: Icons.warning, label: 'Expiring Items'),
      ],
    );
  }
}

class BuildQuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const BuildQuickActionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // handle quick action
      },
      label: Text(label),
      icon: Icon(icon, size: 18),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }
}

class BuildRecentActivity extends StatelessWidget {
  const BuildRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView(
                  children: const [BuildActivityItem(description: 'Item X added (10 units)')],
                ),
              )
            ],
          )),
    );
  }
}

class BuildActivityItem extends StatelessWidget {
  final String description;
  const BuildActivityItem({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
