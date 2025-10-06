import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/models/pokemon_model.dart';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();

  var favoritePokemonItems = <PokemonModel>[].obs;
  // We want to create a Set of IDs for faster lookup when checking if a Pokémon is a favorite.
  RxSet<int> favoriteIds = <int>{}.obs;

  void addFavorite(PokemonModel item) {
    debugPrint('Adding favorite: ${item.name} (ID: ${item.id})');
    if (!favoritePokemonItems.contains(item)) {
      favoritePokemonItems.add(item);
      // keep id set in sync (PokemonModel has an `id` field)
      favoriteIds.add(item.id);
    }
    update();
  }

  void removeFavorite(PokemonModel item) {
    debugPrint('Removing favorite: ${item.name} (ID: ${item.id})');
    favoritePokemonItems.remove(item);
    // keep id set in sync
    favoriteIds.remove(item.id);
    update();
  }

  bool isFavorite(PokemonModel item) {
    debugPrint('Checking if favorite: ${item.name} (ID: ${item.id})');
    // faster check using ids
    return favoriteIds.contains(item.id) || favoritePokemonItems.contains(item);
  }

  /// Toggle favorite state for the given item.
  void toggleFavorite(PokemonModel item) {
    if (isFavorite(item)) {
      removeFavorite(item);
    } else {
      addFavorite(item);
    }
  }
}