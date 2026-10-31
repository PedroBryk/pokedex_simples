import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'pokemon_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex Simples',
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _service = PokemonService();

  Pokemon? _pokemon;
  String? _erro;
  bool _carregando = false;

  Future<void> _buscar() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _carregando = true;
      _erro = null;
      _pokemon = null;
    });

    try {
      final resultado = await _service.buscar(_controller.text);
      setState(() => _pokemon = resultado);
    } catch (e) {
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex Simples')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome ou número do Pokémon',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _buscar, child: const Text('Buscar')),
            const SizedBox(height: 24),
            if (_carregando) const CircularProgressIndicator(),
            if (_erro != null)
              Text(_erro!, style: const TextStyle(color: Colors.red)),
            if (_pokemon != null) _cardPokemon(_pokemon!),
          ],
        ),
      ),
    );
  }

  Widget _cardPokemon(Pokemon p) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(p.imagem, height: 150),
            Text(
              p.nome.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Tipos: ${p.tipos.join(', ')}'),
            Text('Altura: ${p.altura}'),
            Text('Peso: ${p.peso}'),
          ],
        ),
      ),
    );
  }
}