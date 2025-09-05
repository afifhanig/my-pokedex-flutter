import 'package:get/get.dart';
import 'package:my_pokedex_app/data/services/pokemon_services.dart';
import '../../../core/utils.dart';
import '../../../data/models/pokemon_list_response.dart';

class PokemonListController extends GetxController {
  final _service = PokemonService();

  final RxList<PokemonListItem> items = <PokemonListItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;
  final RxMap<String, List<String>> typeCache = <String, List<String>>{}.obs;

  int _offset = 0;
  final int _limit = 30;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    isLoading.value = true;
    error.value = '';
    _offset = 0;
    _hasMore = true;
    items.clear();
    try {
      final res = await _service.fetchPokemonList(
        offset: _offset,
        limit: _limit,
      );
      items.addAll(res.results);
      _offset += _limit;
      _hasMore = res.next != null;
    } catch (e) {
      error.value = 'Failed to load Pokémon list';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMore() async {
    if (!_hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final res = await _service.fetchPokemonList(
        offset: _offset,
        limit: _limit,
      );
      items.addAll(res.results);
      _offset += _limit;
      _hasMore = res.next != null;
    } catch (_) {
      // keep old items; optionally set a footer error UI
    } finally {
      isLoadingMore.value = false;
    }
  }

  String imageUrlFor(PokemonListItem item) {
    final id = extractIdFromUrl(item.url);
    return id == 0 ? '' : officialArtworkUrlFromId(id);
  }

  Future<void> fetchTypeFor(String name) async {
    if (typeCache.containsKey(name)) return;
    try {
      final detail = await _service.fetchPokemonDetailByName(name);
      if (detail.types.isNotEmpty) {
        typeCache[name] = detail.types;
      }
    } catch (_) {
      // ignore errors
    }
  }

  String imageUrlForByName(String name) {
    // Try to find Pokemon from the loaded list
    final item = items.firstWhereOrNull((e) => e.name == name);

    if (item != null) {
      return imageUrlFor(item);
    }

    // If not found (maybe favorites loaded before scrolling to that Pokemon),
    // build url manually using the Pokemon id from its name
    final id = getIdFromName(name);
    if (id != null) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    }

    return '';
  }

  int? getIdFromName(String name) {
    try {
      final item = items.firstWhereOrNull((e) => e.name == name);
      if (item?.url != null) {
        final segments = item!.url.split('/');
        return int.tryParse(segments[segments.length - 2]);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
