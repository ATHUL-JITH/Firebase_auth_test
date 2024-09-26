import 'package:flutter/material.dart';
import 'package:firebase_login/features/home/view/wishlist.dart';
import 'package:provider/provider.dart';
import '../provider/favorites_provider.dart';
import '../provider/pokemon_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    Provider.of<PokemonProvider>(context, listen: false).fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            tooltip: "WishList",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishListPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Pokémon',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PokemonProvider>(
              builder: (context, pokemonProvider, child) {
                final filteredPokemons = pokemonProvider.pokemons.where((pokemon) {
                  return pokemon.name.toLowerCase().contains(_searchTerm);
                }).toList();

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!pokemonProvider.isLoading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      pokemonProvider.fetchPokemons();
                    }
                    return true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: filteredPokemons.length +
                          (pokemonProvider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredPokemons.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final pokemon = filteredPokemons[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100, // Light orange background
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              pokemon.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                Provider.of<FavoritesProvider>(context, listen: false)
                                    .addFavorite(pokemon.name);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
