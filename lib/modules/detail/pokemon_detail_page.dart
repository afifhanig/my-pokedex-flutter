import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pokedex_app/modules/favorites/favorites_controller.dart';
import '../../core/utils.dart';
import '../../data/models/pokemon_detail.dart';
import 'pokemon_detail_controller.dart';

class PokemonDetailPage extends StatefulWidget {
  final String name;
  const PokemonDetailPage({super.key, required this.name});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late final PokemonDetailController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(PokemonDetailController(widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(c.error.value),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: c.loadDetail,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final detail = c.detail.value;
        if (detail == null) return const SizedBox.shrink();

        return DefaultTabController(
          length: 2,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: pokemonTypeColors[detail.types.first],
                ),
              ),
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const TabBar(
                          tabs: [Tab(text: 'About'), Tab(text: 'Stats')],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _AboutTab(detail: detail),
                              _StatsTab(detail: detail),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _Header(detail: detail),
            ],
          ),
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  final PokemonDetail detail;
  const _Header({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Obx(() {
                  final favC = Get.find<FavoriteController>();
                  final isFav = favC.isFavorite(detail.name);
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      favC.toggleFavorite(detail.name);
                    },
                  );
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  capitalize(detail.name),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '#${detail.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children:
                    detail.types
                        .map(
                          (t) => Chip(
                            label: Text(capitalize(t)),
                            backgroundColor:
                                pokemonTypeColors[t] ?? Colors.grey,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 20),
            if (detail.spriteUrl.isNotEmpty)
              Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(detail.spriteUrl, fit: BoxFit.contain),
                ),
              ),
            //
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final PokemonDetail detail;
  const _AboutTab({required this.detail});

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle valueStyle = Theme.of(context).textTheme.titleMedium!;

    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: labelStyle)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          row('ID', '#${detail.id}'),
          row('Name', capitalize(detail.name)),
          row('Height', '${detail.height / 10} m'),
          row('Weight', '${detail.weight / 10} kg'),
          row('Types', detail.types.map(capitalize).join(', ')),
          row('Abilities', detail.abilities.map(capitalize).join(', ')),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  final PokemonDetail detail;
  const _StatsTab({required this.detail});

  int _maxStatValue() {
    // Reasonable upper bound for progress bars
    final max = detail.stats
        .map((s) => s.baseStat)
        .fold<int>(0, (a, b) => a > b ? a : b);
    return max < 100 ? 100 : max; // at least 100
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = _maxStatValue();

    return ListView.separated(
      padding: const EdgeInsets.all(0.0),
      itemCount: detail.stats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final s = detail.stats[index];
        final percent = s.baseStat / maxValue;
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(capitalize(s.name))),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percent.clamp(0, 1).toDouble(),
                      minHeight: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percent > 0.5
                            ? Colors.green
                            : (percent > 0.25 ? Colors.red : Colors.red),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 8),
                // Text('${s.baseStat} / $maxValue'),
              ],
            ),
          ),
        );
      },
    );
  }
}
