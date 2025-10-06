import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/services/pokemon_api.dart';
import 'package:solo_03/models/pokemon_model.dart';

class SearchPokemonController extends GetxController {
  static SearchPokemonController get instance => Get.find();

  var searchNotFound = false.obs;
  var searchText = ''.obs;
  SearchController searchController = SearchController();

  // Observable list of Pokémon for search results and original data from API.
  var fetchedAPIItems = false.obs;
  var searchPokemonItems = <PokemonModel>[].obs;
  late List<PokemonModel> apiPokemonItems = <PokemonModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Initial data load from the Pokémon API
    fetchInitialData();

    once(searchPokemonItems, (_) {
      debugPrint('asdfInitial Pokémon data loaded: ${searchPokemonItems.length} items');
    });

    debounce(searchText, (_) {
      _updatedSearch();
    }, time: const Duration(seconds: 1));
  }

  Future<void> fetchInitialData() async {
    debugPrint('Fetching initial Pokémon data...');

    // Simulate a data load from the Pokémon API
    try {
      fetchedAPIItems.value = true;
      searchPokemonItems.value = apiPokemonItems = await PokeAPI().fetchPokemonList();
    } catch (e) {
      PokeAPI.simulateAPIFail(false);
      debugPrint('Error fetching Pokémon data: $e');
      searchPokemonItems.value = apiPokemonItems = <PokemonModel>[];
    }

    fetchedAPIItems.value = false;
    debugPrint(fetchedAPIItems.value
        ? 'Initial Pokémon data load complete: ${searchPokemonItems.length} items'
        : 'Failed to load initial Pokémon data.');
    // searchPokemonItems.value = _apiPokemonItems = <PokemonModel>[];
  }

  void _updatedSearch() {
    debugPrint('Search text updated: ${searchText.value}');

    // Need to ensure we reset the "not found" flag on each new search
    searchNotFound.value = false;
    
    if (searchText.value.isEmpty) {
      // reset to original API results
      searchPokemonItems.value = apiPokemonItems.toList();
      return;
    }

    final query = searchText.value.toLowerCase().trim();

    // filter from the original list to avoid compounding filters
    final filtered = apiPokemonItems
        .where((pokemon) =>
            pokemon.name.toLowerCase().contains(query) ||
            pokemon.id.toString() == searchText.value);

    if (filtered.isEmpty) {
      debugPrint('No Pokémon found matching: ${searchText.value}');
      searchNotFound.value = true;
    } else {
      debugPrint('Found ${filtered.length} Pokémon matching: ${searchText.value}');
      searchPokemonItems.value = filtered.toList();
    }

  }

}