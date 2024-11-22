// private $post = "INSERT INTO `t_clientes` (`id_cliente`, `nombre`, `correo`, `movil`, `direccion`, `nacimiento`, `observaciones`, `token`, `ingreso`)

class Cliente {
  // ignore: non_constant_identifier_names
  final String id_cliente;
  final String nombre;
  final String correo;
  final String movil;
  final String direccion;
  final String nacimiento;
  final String observaciones;
  final String token;
  final String ingreso;

  const Cliente(
      // ignore: non_constant_identifier_names
      {required this.id_cliente,
      required this.nombre,
      required this.correo,
      required this.movil,
      required this.direccion,
      required this.nacimiento,
      required this.observaciones,
      required this.token,
      required this.ingreso});

  static Cliente fromJson(json) => Cliente(
      id_cliente: json["id_cliente"],
      nombre: json["nombre"],
      correo: json["correo"],
      movil: json["movil"],
      direccion: json["direccion"],
      nacimiento: json["nacimiento"],
      observaciones: json["observaciones"],
      token: json["token"],
      ingreso: json["ingreso"]);
}
