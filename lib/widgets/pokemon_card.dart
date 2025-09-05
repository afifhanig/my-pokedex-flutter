import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<String> types;
  final Color primaryColor;

  const PokemonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // The background pattern circles
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 15,
            child: Text(
              '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                ...types.map((type) => buildTypeChip(type)),
              ],
            ),
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A helper method to build the type chips.
  Widget buildTypeChip(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

/*
To use this widget in your GridView, you would do something like this:

// In your main widget's build method:
GridView.builder(
  padding: const EdgeInsets.all(10),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.9,
  ),
  itemCount: 4, // Replace with the actual number of items
  itemBuilder: (context, index) {
    // You would get the data from your list of Pokémon.
    final pokemonData = [
      {
        'name': 'Bulbasaur',
        'id': '001',
        'imageUrl': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
        'types': ['Grass', 'Poison'],
        'color': const Color(0xFF49D0B0),
      },
      {
        'name': 'Ivysaur',
        'id': '002',
        'imageUrl': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png',
        'types': ['Grass', 'Poison'],
        'color': const Color(0xFF49D0B0),
      },
      {
        'name': 'Venusaur',
        'id': '003',
        'imageUrl': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png',
        'types': ['Grass', 'Poison'],
        'color': const Color(0xFF49D0B0),
      },
      {
        'name': 'Charmander',
        'id': '004',
        'imageUrl': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png',
        'types': ['Fire'],
        'color': const Color(0xFFF9A67F),
      },
    ];

    final pokemon = pokemonData[index];

    return PokemonCard(
      name: pokemon['name'] as String,
      id: pokemon['id'] as String,
      imageUrl: pokemon['imageUrl'] as String,
      types: pokemon['types'] as List<String>,
      primaryColor: pokemon['color'] as Color,
    );
  },
),
*/
