import 'package:flutter/material.dart';
import 'package:solo_03/features/browse/controller/search_controller.dart';
import 'package:solo_03/features/browse/screens/widget/search_pokemon_card.dart';
import 'package:get/get.dart';

class SearchPokemonListView extends StatelessWidget {
  const SearchPokemonListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SearchPokemonController.instance;
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          // shrinkWrap: true,
          itemCount: controller.searchPokemonItems.length,
          itemBuilder: (context, index) {
            return SearchPokemonCard(pokemon: controller.searchPokemonItems[index]);
          },
        ),
      );
    });
  }
}
