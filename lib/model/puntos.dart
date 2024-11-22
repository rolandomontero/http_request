
class Puntos {
  final int id;
  final String fecha;
  final String hora;
  final int puntos;
  final String obs;

  const Puntos({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.puntos,
    required this.obs,
  });

  static Puntos fromJson(json) =>
      Puntos(
        id: json["id_visita"], 
        fecha: json['Fecha'], 
        hora: json['Hora'], 
        puntos: json['puntos'], 
        obs:json['obs']);
}
