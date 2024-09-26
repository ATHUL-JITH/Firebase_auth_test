import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/pokemon_model.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Pokemon> _favorites = [];

  List<Pokemon> get favorites => _favorites;

  Future<void> addFavorite(String pokemonName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).collection('favorites').doc(pokemonName).set({
        'name': pokemonName,
      });
      _favorites.add(Pokemon(name: pokemonName, url: '')); // Optional: Add to local list
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String pokemonName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).collection('favorites').doc(pokemonName).delete();
      _favorites.removeWhere((pokemon) => pokemon.name == pokemonName);
      notifyListeners();
    }
  }

  Stream<List<Pokemon>> getFavorites() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return _firestore.collection('users').doc(userId).collection('favorites').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => Pokemon(name: doc['name'], url: '')).toList();
      });
    } else {
      return Stream.value([]);
    }
  }
}
