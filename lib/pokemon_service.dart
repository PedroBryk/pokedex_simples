import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class PokemonService {
  Future<Pokemon> buscar(String nome) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${nome.trim().toLowerCase()}',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(resposta.body));
    } else if (resposta.statusCode == 404) {
      throw Exception('Pokémon não encontrado');
    } else {
      throw Exception('Erro ao buscar (código ${resposta.statusCode})');
    }
  }
}