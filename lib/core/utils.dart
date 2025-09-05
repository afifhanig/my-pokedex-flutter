import 'package:flutter/material.dart';

int extractIdFromUrl(String url) {
  // e.g. https://pokeapi.co/api/v2/pokemon/25/ -> 25
  final parts = url.split('/');
  for (int i = parts.length - 1; i >= 0; i--) {
    if (parts[i].isNotEmpty) {
      return int.tryParse(parts[i]) ?? 0;
    }
  }
  return 0;
}

String officialArtworkUrlFromId(int id) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

final Map<String, Color> pokemonTypeColors = {
  'normal': Colors.brown.shade400,
  'fire': Colors.redAccent,
  'water': Colors.blueAccent,
  'electric': Colors.amber,
  'grass': Colors.green,
  'ice': Colors.cyanAccent,
  'fighting': Colors.orange,
  'poison': Colors.purple,
  'ground': Colors.brown,
  'flying': Colors.indigoAccent,
  'psychic': Colors.pinkAccent,
  'bug': Colors.lightGreen,
  'rock': Colors.grey,
  'ghost': Colors.indigo,
  'dragon': Colors.indigo.shade900,
  'dark': Colors.black54,
  'steel': Colors.blueGrey,
  'fairy': Colors.pinkAccent.shade100,
};
