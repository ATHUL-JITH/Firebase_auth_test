import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/pokemon_model.dart';

class PokemonProvider with ChangeNotifier {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon";
  List<Pokemon> _pokemons = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;

  List<Pokemon> get pokemons => _pokemons;
  bool get isLoading => _isLoading;

  Future<void> fetchPokemons() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('$baseUrl?offset=$_offset&limit=$_limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _pokemons.addAll((data['results'] as List).map((json) => Pokemon.fromJson(json)).toList());
      _offset += _limit;
    } else {
      throw Exception('Failed to load Pokémon');
    }

    _isLoading = false;
    notifyListeners();
  }
}
