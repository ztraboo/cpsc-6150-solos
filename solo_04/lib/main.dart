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
  bool _adminMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadAdminMode();
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

  Future<void> _loadAdminMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _adminMode = prefs.getBool('adminMode') ?? false);
  }

  Future<void> _setAdminMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adminMode', value);
    setState(() => _adminMode = value);
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
        adminMode: _adminMode,
        onToggleAdmin: () => _setAdminMode(!_adminMode)
      ),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
    required this.adminMode,
    required this.onToggleAdmin,
  });

  final bool darkMode;
  final VoidCallback onToggleTheme;
  final bool adminMode;
  final VoidCallback onToggleAdmin;

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;
  // static const _labels = ['USU Preferences', 'USU Events', 'USU Sign Up'];

  @override
  void didUpdateWidget(covariant HomeScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ensure selected index remains valid when adminMode toggles and available pages change.
    final oldPagesCount = oldWidget.adminMode ? 3 : 2;
    final newPagesCount = widget.adminMode ? 3 : 2;

    // If toggling adminMode ON and we were on the old last (Preferences),
    // map to the new last so Preferences remains selected.
    if (!oldWidget.adminMode && widget.adminMode) {
      if (_selectedIndex == oldPagesCount - 1) {
        setState(() => _selectedIndex = newPagesCount - 1);
        return;
      }
    }

    if (_selectedIndex >= newPagesCount) {
      setState(() => _selectedIndex = newPagesCount - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build pages, destinations and labels in the same order so indices align.
    final pages = widget.adminMode
        ? <Widget>[
            EventsScreen(darkMode: widget.darkMode),
            SignUpScreen(darkMode: widget.darkMode),
            PreferencesScreen(
              onToggleTheme: widget.onToggleTheme,
              darkMode: widget.darkMode,
              onToggleAdmin: widget.onToggleAdmin,
              adminMode: widget.adminMode,
            ),
          ]
        : <Widget>[
            SignUpScreen(darkMode: widget.darkMode),
            PreferencesScreen(
              onToggleTheme: widget.onToggleTheme,
              darkMode: widget.darkMode,
              onToggleAdmin: widget.onToggleAdmin,
              adminMode: widget.adminMode,
            ),
          ];

    final destinations = widget.adminMode
        ? <NavigationDestination>[
            const NavigationDestination(icon: Icon(Icons.list), label: 'Events'),
            const NavigationDestination(icon: Icon(Icons.person_add), label: 'Sign Up'),
            const NavigationDestination(icon: Icon(Icons.tune), label: 'Preferences'),
          ]
        : <NavigationDestination>[
            const NavigationDestination(icon: Icon(Icons.person_add), label: 'Sign Up'),
            const NavigationDestination(icon: Icon(Icons.tune), label: 'Preferences'),
          ];

    final labels = widget.adminMode
        ? ['USU Events', 'USU Sign Up', 'USU Preferences']
        : ['USU Sign Up', 'USU Preferences'];

    final currentIndex = (_selectedIndex < pages.length) ? _selectedIndex : (pages.length - 1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(labels[currentIndex]),
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
        index: currentIndex,
        children: pages,
      ),
      floatingActionButton: (widget.adminMode && currentIndex == 0)
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
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: destinations,
      ),
    );
  }
}
