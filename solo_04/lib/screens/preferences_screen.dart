import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({
    super.key,
    required this.onToggleTheme,
    required this.darkMode,
    required this.onToggleAdmin,
    required this.adminMode,
  });

  final VoidCallback onToggleTheme;
  final bool darkMode;
  final VoidCallback onToggleAdmin;
  final bool adminMode;

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for a better night-time experience.'),
            value: widget.darkMode,
            onChanged: (value) {
              widget.onToggleTheme();
            },
          ),
          SwitchListTile(
            title: const Text('Admin Mode'),
            subtitle: const Text('Enable admin features to manage events.'),
            value: widget.adminMode,
            onChanged: (value) {
              widget.onToggleAdmin();
            },
          ),
        ],
      ), 
    );
  }
}