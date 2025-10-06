import 'package:flutter/material.dart';
import 'package:solo_03/features/favorites/controller/favorites_controller.dart';
import 'package:solo_03/features/favorites/screens/widgets/favorite_pokemon_card.dart';
import 'package:get/get.dart';

class FavoritesPokemonListView extends StatelessWidget {
  const FavoritesPokemonListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavoritesController.instance;
    
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          // shrinkWrap: true,
          itemCount: controller.favoritePokemonItems.length,
          itemBuilder: (context, index) {
            return FavoritePokemonCard(pokemon: controller.favoritePokemonItems[index]);
          },
        ),
      );
    });
  }
}
