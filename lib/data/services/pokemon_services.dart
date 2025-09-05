import 'package:dio/dio.dart';
import 'package:my_pokedex_app/data/models/pokemon_detail.dart';
import 'package:my_pokedex_app/data/models/pokemon_list_response.dart';
import '../../../core/api_client.dart';

class PokemonService {
  final Dio _dio = ApiClient.dio;

  Future<PokemonListResponse> fetchPokemonList({
    int offset = 0,
    int limit = 30,
  }) async {
    final res = await _dio.get(
      '/pokemon',
      queryParameters: {'offset': offset, 'limit': limit},
    );
    return PokemonListResponse.fromJson(res.data);
  }

  Future<PokemonDetail> fetchPokemonDetailByName(String name) async {
    final res = await _dio.get('/pokemon/$name');
    return PokemonDetail.fromJson(res.data);
  }
}
