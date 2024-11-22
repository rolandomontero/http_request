
class Puntos {
  final int id;
  final String fecha;
  final String hora;
  final int puntos;
  final String observacion;

  const Puntos({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.puntos,
    required this.observacion,
  });
// "[{"id_visita":1105,"fecha":"22 Nov 2024","hora":"05:57 PM","puntos":10,"observacion":"Compra"},{"id_visita":1041,"fecha":"06 Nov…"
  static Puntos fromJson(json) =>
      Puntos(
        id: json["id_visita"], 
        fecha: json['fecha'], 
        hora: json['hora'], 
        puntos: json['puntos'], 
        observacion:json['observacion']);
}
