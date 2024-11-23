import 'dart:convert';

import 'package:http_request/global/const.dart';
import 'package:http_request/model/cliente.dart';
import 'package:http_request/model/premio.dart';
import 'package:http_request/model/puntos.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  late Cliente _user;

  // User Cliente SignUp
  Future<String> signupUser({
    required String nombre,
    required String email,
    required String telefono,
    required String domicilio,
    required DateTime? fechaNacimiento,
  }) async {
    try {
      // Extrae el id_cliente del teléfono sin el '+'
      final movil = telefono.substring(1);

      DateTime now = DateTime.now();
      String ingreso = DateFormat('yyyy-MM-dd').format(now);

      // Formatea la fecha de nacimiento
      String formattedNacimiento = fechaNacimiento != null
          ? DateFormat('yyyy-MM-dd').format(fechaNacimiento)
          : '';

      // Construye la URL de la API
      final url = Uri.parse(
          '$uLocal/cliente?nombre=$nombre&correo=$email&movil=%2B$movil&direccion=$domicilio&nacimiento=$formattedNacimiento&token=null&ingreso=$ingreso&observaciones=null');

      print(url);

      // Realiza la petición POST a la API
      final response = await http.post(url);

      if (response.statusCode == 201) {
        // Si la respuesta es exitosa, decodifica el JSON
        final dynamic decodedBody = json.decode(response.body);
        print(decodedBody);

        // Crea una instancia de Cliente con los datos del JSON
        final cliente = Cliente.fromJson(decodedBody);

        // Guarda los datos del cliente en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id_cliente', cliente.id_cliente);
        await prefs.setString('nombre', cliente.nombre);
        await prefs.setString('correo', cliente.correo);
        await prefs.setString('movil', cliente.movil);
        await prefs.setString('direccion', cliente.direccion);
        await prefs.setString('nacimiento', cliente.nacimiento);
        await prefs.setString('observaciones', cliente.observaciones);
        await prefs.setString('token', cliente.token);
        await prefs.setString('ingreso', cliente.ingreso);

        return 'success'; // Inicio de sesión exitoso
      } else {
        throw Exception('Fallo de Lectura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return e.toString(); // Devolver el error como String
    }
  }

  // User Cliente Login
  Future<String> loginUser(String idCliente) async {
    try {
      final url = Uri.parse('$uLocal/cliente?id_cliente=${idCliente.trim()}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        if (decodedBody is Map<String, dynamic>) {
          final cliente = Cliente.fromJson(decodedBody);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('id_cliente', cliente.id_cliente);
          await prefs.setString('nombre', cliente.nombre);
          await prefs.setString('correo', cliente.correo);
          await prefs.setString('movil', cliente.movil);
          await prefs.setString('direccion', cliente.direccion);
          await prefs.setString('nacimiento', cliente.nacimiento);
          await prefs.setString('observaciones', cliente.observaciones);
          await prefs.setString('token', cliente.token);
          await prefs.setString('ingreso', cliente.ingreso);
          return 'success';
        } else {
          throw Exception('La respuesta no es un JSON válido');
        }
      } else {
        throw Exception('Fallo de Lectura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return e.toString();
    }
  }

  Future<bool> registrado() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString('nombre') ?? '') != '' ? true : false;
  }

// Cliente Load Memory
  Future<Cliente> loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    _user = Cliente(
      id_cliente: prefs.getString('id_cliente') ?? '',
      nombre: prefs.getString('nombre') ?? '',
      correo: prefs.getString('correo') ?? '',
      movil: prefs.getString('movil') ?? '',
      direccion: prefs.getString('direccion') ?? '',
      nacimiento: prefs.getString('nacimiento') ?? '',
      observaciones: prefs.getString('observaciones') ?? '',
      token: prefs.getString('token') ?? '',
      ingreso: prefs.getString('ingreso') ?? '',
    );
    return _user;
  }

  Future<String> nombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nombre') ?? '';
  }

  Future<String> idCliente() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_cliente') ?? '';
  }

  // Cliente Sign Out User
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_cliente');
    await prefs.remove('nombre');
    await prefs.remove('correo');
    await prefs.remove('movil');
    await prefs.remove('direccion');
    await prefs.remove('nacimiento');
    await prefs.remove('observaciones');
    await prefs.remove('token');
    await prefs.remove('ingreso');
  }

  Future<int> total(String idCliente) async {
    try {
      final url = Uri.parse('$uLocal/puntos?total=$idCliente');
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      final totalInt = int.parse(data['total'] as String);
      return totalInt;
    } catch (e) {
      print('Error al obtener el total: $e');
      // Maneja el error, por ejemplo, retornando un valor por defecto o lanzando una excepción
      return 0; // O throw e;
    }
  }

  // Función para obtener puntos del cliente
  static Future<List<Puntos>> getPuntos(String idCliente) async {
    final url = Uri.parse('$uLocal/puntos?id_cliente=$idCliente');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data.map<Puntos>((json) => Puntos.fromJson(json)).toList();
  }

  Future<bool> enviarPuntos(String idCliente, int puntos) async {
    try {
      var guardado = false;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);
      String ruta = '$uLocal/puntos?id_cliente=$idCliente'
          '&fecha=$formattedDate&hora=$formattedTime'
          '&puntos=${puntos.toString()}'
          '&observacion=Compra';

      final url = Uri.parse(ruta);
      final response = await http.post(url);

      if (response.statusCode == 201) {
        guardado = true;
      } else {
        throw Exception('Fallo al guardar puntos');
      }
      return guardado;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }

// Función para  obtener las lista de Premios
  static Future<List<Premio>> getPremios() async {
    final response = await http.get(Uri.parse(uPremios));
    final data = jsonDecode(response.body);
   // print(data);
    return data.map<Premio>((json) => Premio.fromJson(json)).toList();
  }


 



}
