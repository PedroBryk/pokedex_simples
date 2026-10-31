class Pokemon {
  final String nome;
  final int altura;
  final int peso;
  final String imagem;
  final List<String> tipos;

  Pokemon({
    required this.nome,
    required this.altura,
    required this.peso,
    required this.imagem,
    required this.tipos,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      nome: json['name'],
      altura: json['height'],
      peso: json['weight'],
      imagem: json['sprites']['front_default'] ?? '',
      tipos: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
    );
  }
}