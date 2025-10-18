import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({
    super.key,
    required this.onToggleTheme,
    required this.darkMode,
  });

  final VoidCallback onToggleTheme;
  final bool darkMode;

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
            value: widget.darkMode,
            onChanged: (value) {
              widget.onToggleTheme();
            },
          ),
        ],
      ), 
    );
  }
}