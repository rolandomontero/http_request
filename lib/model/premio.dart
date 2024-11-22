class Premio {
  final int idPremio;
  final String publicado;
  final String vence;
  final String categoria;
  final String promo;
  final int puntos;
  final bool activo;

  Premio({
    required this.idPremio,
    required this.publicado,
    required this.vence,
    required this.categoria,
    required this.promo,
    required this.puntos,
    required this.activo,
  });

  // Constructor desde un mapa JSON
  factory Premio.fromJson(Map<String, dynamic> json) {
    return Premio(
      idPremio: json['id_premio'],
      publicado: json['publicado'],
      vence: json['vence'],
      categoria: json['categoria'],
      promo: json['promo'],
      puntos: json['puntos'],
      activo: json['activo'] == 1, // Convertimos el valor a booleano
    );
  }
}