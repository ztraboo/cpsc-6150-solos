import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/favorites/controller/favorites_controller.dart';
import 'package:solo_03/features/favorites/screens/widgets/favorite_not_found.dart';
import 'package:solo_03/features/favorites/screens/widgets/favorite_pokemon_list_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(FavoritesController());

    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 16.0,right: 16.0),
        child: Column(
          children: [
            controller.favoritePokemonItems.isEmpty
                ? const FavoritesNotFound()
                : const FavoritesPokemonListView(),
          ],
        )
      ),
    );
  }
}


