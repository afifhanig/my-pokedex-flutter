import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pokedex_app/widgets/pokemon_card.dart';
import '../../core/utils.dart';
import 'pokemon_list_controller.dart';
import '../detail/pokemon_detail_page.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final PokemonListController c;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    c = Get.put(PokemonListController());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      c.fetchMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex'), centerTitle: false),
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
                  onPressed: c.fetchInitial,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: c.fetchInitial,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: c.items.length + 1,
            itemBuilder: (context, index) {
              if (index == c.items.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child:
                        c.isLoadingMore.value
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                  ),
                );
              }
              final item = c.items[index];
              final imageUrl = c.imageUrlFor(item);

              // get type if cached, else trigger fetch
              if (!c.typeCache.containsKey(item.name)) {
                Future.microtask(() => c.fetchTypeFor(item.name));
              }

              return Obx(() {
                final types = c.typeCache[item.name] ?? [];
                final cardColor =
                    types.isNotEmpty
                        ? pokemonTypeColors[types.first] ?? Colors.grey.shade200
                        : Colors.grey.shade200;

                return GestureDetector(
                  onTap: () => Get.to(PokemonDetailPage(name: item.name)),
                  child: PokemonCard(
                    name: capitalize(item.name),
                    imageUrl: imageUrl,
                    types: types,
                    primaryColor: cardColor,
                  ),
                );
              });
            },
          ),
        );
      }),
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,

        child: FloatingActionButton(
          backgroundColor: Colors.teal.shade300,
          onPressed: () => Get.toNamed('/favorites'),
          child: FittedBox(
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 8),
                Text('Favorites', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
