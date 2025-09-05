import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pokedex_app/modules/favorites/favorites_controller.dart';
import '../../core/utils.dart';
import '../detail/pokemon_detail_page.dart';
import '../list/pokemon_list_controller.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favC = Get.find<FavoriteController>();
    final listC = Get.find<PokemonListController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: Obx(() {
        if (favC.favorites.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        final favList = favC.favorites.toList();

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: favList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final name = favList[index];
            final imageUrl = listC.imageUrlForByName(name);
            final types = listC.typeCache[name] ?? [];

            final cardColor =
                types.isNotEmpty
                    ? pokemonTypeColors[types.first] ?? Colors.grey.shade200
                    : Colors.grey.shade200;

            return Card(
              color: cardColor,
              child: ListTile(
                leading:
                    imageUrl.isEmpty
                        ? const SizedBox(width: 56, height: 56)
                        : Image.network(
                          imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                        ),
                title: Text(
                  capitalize(name),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle:
                    types.isNotEmpty
                        ? Wrap(
                          spacing: 6,
                          children:
                              types
                                  .map(
                                    (t) => Chip(
                                      label: Text(capitalize(t)),
                                      backgroundColor:
                                          pokemonTypeColors[t] ?? Colors.grey,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        )
                        : null,
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () => Get.to(() => PokemonDetailPage(name: name)),
              ),
            );
          },
        );
      }),
    );
  }
}
