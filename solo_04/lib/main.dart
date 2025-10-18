import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_04/screens/create_events_screen.dart';
import 'package:solo_04/screens/events_screen.dart';
import 'package:solo_04/screens/preferences_screen.dart'; 
import 'package:solo_04/screens/signup_screen.dart';


void main() => runApp(const EventFormApp());

class EventFormApp extends StatefulWidget {
  const EventFormApp({super.key});

  @override
  State<EventFormApp> createState() => _EventFormAppState();
}

class _EventFormAppState extends State<EventFormApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _darkMode = prefs.getBool('darkMode') ?? false);
  }

  Future<void> _setTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() => _darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Creator',
      theme: ThemeData(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.indigo,
        // textTheme: TextTheme(
        //   titleLarge: TextStyle(color: (_darkMode ? Colors.white : Colors.black)),
        //   bodyMedium: TextStyle(color: (_darkMode ? Colors.white70 : Colors.black87)),
        // ),
        useMaterial3: true,
      ),
      home: HomeScaffold(
        darkMode: _darkMode,
        onToggleTheme: () => _setTheme(!_darkMode),
      ),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
  });

  final bool darkMode;
  final VoidCallback onToggleTheme;

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;
  static const _labels = ['USU Preferences', 'USU Events', 'USU Sign Up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_labels[_selectedIndex]),
        // backgroundColor: Colors.blueGrey.shade200,
        actions: [
          IconButton(
            tooltip: 'Toggle Theme (saved in SharedPreferences)',
            icon: Icon(widget.darkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PreferencesScreen(
            onToggleTheme: widget.onToggleTheme,
            darkMode: widget.darkMode
          ),
          EventsScreen(
            darkMode: widget.darkMode
          ),
          SignUpScreen(
            darkMode: widget.darkMode
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                try {
                  debugPrint('Opening CreateEventScreen...');
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateEventScreen(),
                    ),
                  );
                  debugPrint('Returned from CreateEventScreen');
                } catch (e, st) {
                  debugPrint('Error opening CreateEventScreen: $e\n$st');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error opening Create Event: $e')),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: 'Preferences'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.person_add), label: 'Sign Up'),
        ],
      ),
    );
  }
}
