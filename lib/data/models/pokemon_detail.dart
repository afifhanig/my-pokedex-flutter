class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final String spriteUrl;
  final List<StatItem> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.spriteUrl,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final official = (other?['official-artwork'] ?? {}) as Map<String, dynamic>;

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types:
          (json['types'] as List)
              .map((t) => t['type']['name'] as String)
              .cast<String>()
              .toList(),
      abilities:
          (json['abilities'] as List)
              .map((a) => a['ability']['name'] as String)
              .cast<String>()
              .toList(),
      spriteUrl:
          (official['front_default'] ?? sprites['front_default'] ?? '')
              as String,
      stats: (json['stats'] as List).map((s) => StatItem.fromJson(s)).toList(),
    );
  }
}

class StatItem {
  final String name;
  final int baseStat;

  StatItem({required this.name, required this.baseStat});

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(name: json['stat']['name'], baseStat: json['base_stat']);
  }
}
