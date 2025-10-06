import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/favorites/controller/favorites_controller.dart';
import 'package:solo_03/models/pokemon_model.dart';

class FavoritePokemonCard extends StatelessWidget {
  const FavoritePokemonCard({super.key, required this.pokemon});

  final PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    
    return Card(
      margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        minTileHeight: 100.0,
        leading: SizedBox(
          width: 160,
          height: 160,
          child: Row(
            children: [
              (pokemon.spriteImageUrl != null)
                  ? Image.network(
                      pokemon.spriteImageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.pets),
                    ),
              SizedBox(width: 10.0),
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.deepOrange,
                child: Text(
                    '#${pokemon.id}',
                    style: TextStyle(color: Colors.white),
                ),
              ), // 
            ],
          ),
        ),
        title: Text(
          pokemon.name.isEmpty
              ? ''
              : pokemon.name[0].toUpperCase() +
                  pokemon.name.substring(1),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Height:', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8.0),
                    Text('${pokemon.height}'),
                  ],
                ),
                SizedBox(height: 1.0),
                Row(
                  children: [
                    Text('Weight:', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6.0),
                    Text('${pokemon.weight}'),
                  ],
                ),
              ],
            ), //
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black, size: 30,),
          onPressed: () {
            controller.removeFavorite(pokemon);
          },
        ),
      ),
    );
  }
}
