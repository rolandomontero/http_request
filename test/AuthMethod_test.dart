// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:http_request/services/authentication.dart';

void main() {
  // Pruebas al API request
  test('Prueba de lectura de puntos', () async {
    final AuthMethod authMethod = AuthMethod();
    expect(await authMethod.total('56977838836'), 1067);
  });

  test('Prueba de envios de puntos', () async {
    final AuthMethod authMethod = AuthMethod();
    expect(await authMethod.enviarPuntos('56977838836', 10), true);
  });

  test('Lista de Premios', () async {
      final premios = await AuthMethod.getPuntos('56977838836');
     print(premios); // Imprime la lista de premios en la consola
  expect(premios.isNotEmpty, true); // Verifica que la lista no esté vacía

  });





}
