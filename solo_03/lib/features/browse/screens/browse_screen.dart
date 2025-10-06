import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/browse/controller/search_controller.dart';
import 'package:solo_03/features/browse/screens/widget/search_api_failed_load.dart';
import 'package:solo_03/features/browse/screens/widget/search_not_found.dart';
import 'package:solo_03/features/browse/screens/widget/search_pokemon_list_view.dart';  

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPokemonController());

    return Obx(
        () => 
        // Pokemon API models do not exist (failed to load).
        (controller.fetchedAPIItems.value && controller.apiPokemonItems.isEmpty) ?
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const PokeAPIFailedToLoad(),
              ),
            ],
          ) :
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: controller.fetchedAPIItems.value
                ? Center(child: SpinKitFadingCube(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.amber : Colors.red,
                        ),
                      );
                    },
                  ))
                : 
                Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchAnchor(
                          builder: (BuildContext context, SearchController sController) {
                            // Make sure to reset the SearchController text to match the observable value.
                            // This keeps the text whenever the user goes from Favorites back to Browse.
                            sController.text = controller.searchText.value;

                            return SearchBar(
                              controller: sController,
                              padding: const WidgetStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              // onTap: () {
                              //   controller.openView();
                              // },
                              onChanged: (_) {
                                // controller.openView();
                                controller.searchText.value = sController.text;
                              },
                              leading: const Icon(Icons.search),
                              trailing: [
                                if (sController.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      sController.clear();
                                      controller.searchText.value = '';
                                      // controller.closeView();
                                    },
                                  ),
                              ],
                            );
                          },
                          suggestionsBuilder: (BuildContext context, SearchController controller) {
                            return [];
                          },
                        ),
                      ),  
                      const Gap(10),
                      // const TOptionBar(),
                      const Gap(10),

                      // Search returned no results from Pokemon API models.
                      (controller.searchPokemonItems.isEmpty) ||

                      // Pokemon API models exist, but no matches found for search text.
                      (controller.searchPokemonItems.isNotEmpty && controller.searchNotFound.value == true) ? 

                        const SearchNotFound() :

                        // Pokemon API models exist and matches found for search text.
                        const SearchPokemonListView()
                    ],
                  ),
          ),
      );
  }
}

// class BrowseScreen extends StatefulWidget {
//   const BrowseScreen({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<BrowseScreen> createState() => _BrowseScreenState();
// }

// class _BrowseScreenState extends State<BrowseScreen> {
  // bool _loading = true;
  // List<PokemonModel> _searchResults = [];

  // @override
  // void initState() {
  //   super.initState();
  //   // Simulate an initial data load from the Pokémon API
  //   _loadSearchResults();
  // }

  // Future<void> _loadSearchResults() async {
  //   // Simulate a data load from the Pokémon API
  //   final results = await PokeAPI().fetchPokemonList();

  //   // Delay for 2 seconds to mimic network call
  //   await Future.delayed(const Duration(seconds: 2));

  //   setState(() {
  //     _searchResults = results;
  //     _loading = false;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // if (_loading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       //
    //       // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
    //       // action in the IDE, or press "p" in the console), to see the
    //       // wireframe for each widget.
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
            
    //         _searchResults.isEmpty
    //             ? const Text('No Pokémon found.')
    //             : Expanded(
    //                 child: ListView.builder(
    //                   itemCount: _searchResults.length,
    //                   itemBuilder: (context, index) {
    //                     final pokemon = _searchResults[index];
    //                     return Card(
    //                       margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
    //                       elevation: 2,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(16),
    //                       ),
    //                       child: ListTile(
    //                         minTileHeight: 100.0,
    //                         leading: SizedBox(
    //                           width: 160,
    //                           height: 160,
    //                           child: Row(
    //                             children: [
    //                               (pokemon.spriteImageUrl != null)
    //                                   ? Image.network(
    //                                       pokemon.spriteImageUrl!,
    //                                       width: 100,
    //                                       height: 100,
    //                                       fit: BoxFit.cover,
    //                                       alignment: Alignment.center,
    //                                     )
    //                                   : Container(
    //                                       width: 100,
    //                                       height: 100,
    //                                       color: Colors.grey[300],
    //                                       child: const Icon(Icons.pets),
    //                                     ),
    //                               SizedBox(width: 10.0),
    //                               CircleAvatar(
    //                                 radius: 25.0,
    //                                 backgroundColor: Colors.deepOrange,
    //                                 child: Text(
    //                                     '#${pokemon.id}',
    //                                     style: TextStyle(color: Colors.white),
    //                                 ),
    //                               ), // sho
    //                             ],
    //                           ),
    //                         ),
    //                         title: Text(pokemon.name.isEmpty ? '' : pokemon.name[0].toUpperCase() + pokemon.name.substring(1), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // show name
    //                         subtitle: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Row(
    //                               children: [
    //                                 Text('Height:', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
    //                                 const SizedBox(width: 8.0),
    //                                 Text('${pokemon.height}'),
    //                               ],
    //                             ),
    //                             SizedBox(height: 1.0),
    //                             Row(
    //                               children: [
    //                                 Text('Weight:', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
    //                                 const SizedBox(width: 6.0),
    //                                 Text('${pokemon.weight}'),
    //                               ],
    //                             ),
    //                           ],
    //                         ), // show
    //                         trailing: Padding(
    //                           padding: const EdgeInsets.all(1.0),
    //                           child: IconButton.filledTonal(
    //                             onPressed: () => {}, // _toggleFavorite(pokemon.id),
    //                             icon: Icon(Icons.star_border), // isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
    //                             tooltip: 'Favorite Pokémon',
    //                             iconSize: 35.0
    //                           ),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //       ],
    //     ),
    //   ),
    // );
  // }
// }
