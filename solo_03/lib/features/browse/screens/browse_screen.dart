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
          (controller.fetchedAPIItems.value) ?
              // Fetching data from Pokemon API.
              Center(child: SpinKitFadingCube(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.amber : Colors.red,
                      ),
                    );
                  },
                ))
              : 
                // Pokemon API models do not exist (failed to load data from API).
                (controller.apiPokemonItems.isEmpty) ?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const PokeAPIFailedToLoad(),
                    ),
                  ],
                ) :
                // Pokemon API models exist, show search bar and list of Pokémon.
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                  child: 
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
