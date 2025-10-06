/// Simple Dart model for a Pokémon record
class PokemonModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String? spriteImageUrl;
  // late bool _isFavorite; // Doesn't work because this always gets reset on fetch

  PokemonModel({required this.id, required this.name, required this.height, required this.weight, this.spriteImageUrl});
  // Pokemon({required this.id, required this.name, required this.height, required this.weight, this.spriteImageUrl, bool isFavorite = false})
  //     : _isFavorite = isFavorite;

  // bool get isFavorite => _isFavorite;
  // set isFavorite(bool value) {
  //   _isFavorite = value;
  // }

  /// Factory constructor to build a Pokémon from JSON
  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    // Pattern matching ensures keys exist and types are correct
    return switch (json) {
      {'id': int id, 'name': String name, 'height': int height, 'weight': int weight, 'sprites': Map<String, dynamic> sprites} =>
        PokemonModel(
          id: id,
          name: name,
          height: height,
          weight: weight,
          spriteImageUrl: sprites['other']?['official-artwork']?['front_shiny'] as String?,
        ),
      _ => throw const FormatException('Unexpected JSON shape for Pokémon API'),
    };
  }

  /// Convert a Pokémon instance back to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'height': height,
        'weight': weight,
        'spriteImageUrl': spriteImageUrl,
      };  
}