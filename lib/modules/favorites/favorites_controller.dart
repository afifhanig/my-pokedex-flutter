import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteController extends GetxController {
  static const String storageKey = 'favorites';
  final _box = GetStorage();

  final RxSet<String> favorites = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = _box.read<List>(storageKey) ?? [];
    favorites.addAll(stored.cast<String>());
  }

  bool isFavorite(String name) => favorites.contains(name);

  void toggleFavorite(String name) {
    if (favorites.contains(name)) {
      favorites.remove(name);
    } else {
      favorites.add(name);
    }
    _box.write(storageKey, favorites.toList());
  }
}
