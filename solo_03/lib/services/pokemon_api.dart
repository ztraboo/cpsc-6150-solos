import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokeAPI {
  // Singleton pattern
  static final PokeAPI _instance = PokeAPI._internal();
  factory PokeAPI() => _instance;
  PokeAPI._internal();

  bool _simulateAPIFail = true;
  static simulateAPIFail(bool testing) {
    if (testing) {
      debugPrint('PokeAPI: Testing mode enabled.');
      _instance._simulateAPIFail = true;
    }
    else {
      debugPrint('PokeAPI: Testing mode disabled.');
      _instance._simulateAPIFail = false;
    }
  }

  // Define the base URL for the Pokémon API
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // Fetch a list of Pokémon
  Future<List<PokemonModel>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/?limit=151')).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again!');
      },
    );
    if (!_simulateAPIFail && response.statusCode == 200) {
      // Simulate a delay to mimic network call (5 seconds)
      // await Future.delayed(const Duration(seconds: 5));

      final data = json.decode(response.body);
      final results = data['results'] as List;
      final futures = results.map((item) async {
        final String idStr = (item['url'] as String).split('/').reversed.elementAt(1);
        return await fetchPokemonDetails(idStr);
      }).toList();
      return Future.wait(futures);
    } else {
      throw Exception('PokeAPI: Failed to load Pokémon list, status code: ${response.statusCode}');
    }
  }

  // Fetch details for a specific Pokémon
  Future<PokemonModel> fetchPokemonDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
    if (response.statusCode == 200) {
      return PokemonModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('PokeAPI: Failed to load Pokémon details for ID $id, status code: ${response.statusCode}');
    }
  }
}