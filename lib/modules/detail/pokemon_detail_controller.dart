import 'package:get/get.dart';
import 'package:my_pokedex_app/data/services/pokemon_services.dart';
import '../../data/models/pokemon_detail.dart';

class PokemonDetailController extends GetxController {
  final String name;
  PokemonDetailController(this.name);

  final Rx<PokemonDetail?> detail = Rx<PokemonDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final _service = PokemonService();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await _service.fetchPokemonDetailByName(name);
      detail.value = data;
    } catch (e) {
      error.value = 'Failed to load detail for $name';
    } finally {
      isLoading.value = false;
    }
  }
}
