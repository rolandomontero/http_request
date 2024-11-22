//                {
//                   'imagePath': 'assets/images/tablas/tabla1.png',
//                   'tabla': 'Tabla 1',
//                   'bocados': '24 bocados',
//                   'ingrediente':
//                       '* Makisushi (Palta o salmón) \n * 1 california rolls (semillas mix) \n * Hosomaki',
//                   'precio': ' \$ 13.900',
//                 },

class Carta {
  final String imagePath;
  final String tabla;
  final String bocados;
  final String ingrediente;
  final String precio;

  const Carta({
    required this.imagePath,
    required this.tabla,
    required this.bocados,
    required this.ingrediente,
    required this.precio,
  });

  static Carta fromJson(json) => Carta(
        imagePath: json["imagePath"],
        tabla: json["tabla"],
        bocados: json["bocados"],
        ingrediente: json["ingrediente"],
        precio: json["precio"],
      );
}
