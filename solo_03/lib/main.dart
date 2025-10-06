import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/browse/screens/browse_screen.dart';
import 'package:solo_03/features/favorites/screens/favorites_screen.dart';
import 'package:solo_03/features/favorites/screens/widgets/favorite_badge.dart';
import 'package:solo_03/features/favorites/controller/favorites_controller.dart';

void main() async {
  // Ensure Flutter engine is ready before any async work (e.g., opening a DB)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PokemonCatalogApp());
}

class PokemonCatalogApp extends StatefulWidget {
  const PokemonCatalogApp({super.key});

  @override
  State<PokemonCatalogApp> createState() => _PokemonCatalogAppState();
}

class _PokemonCatalogAppState extends State<PokemonCatalogApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Catalog',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PokemonHomeShell(title: 'Pokémon Catalog'),
    );
  }
}

class PokemonHomeShell extends StatefulWidget {
  final String title;

  const PokemonHomeShell({super.key, required this.title});

  @override
  State<PokemonHomeShell> createState() => _PokemonHomeShellState();
}

class _PokemonHomeShellState extends State<PokemonHomeShell> {
  int currentScreenIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);

    final pages = [
      BrowseScreen(),
      FavoritesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Pokémon Catalog'),
      ),
      body: pages[currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          debugPrint('Switching to screen $index');
          setState(() {
            currentScreenIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        elevation: 5,
        selectedIndex: currentScreenIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.home_outlined),
            label: 'Browse',
            tooltip: 'Browse Pokédex',
          ),
          NavigationDestination(
            icon: FavoritesBadge(),
            label: 'Favorites',
            tooltip: 'View Favorites',
          ),
        ],
      ),
    );
  }
}

