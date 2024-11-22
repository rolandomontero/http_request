import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'class/puntos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wampus UpDate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UpDate Wampus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController phoneNumberController = 
      MaskedTextController(mask: '+56900000000', text: '+56');
  final TextEditingController puntosNumberController = TextEditingController();

  String cliente = '';
  String msgbusqueda = 'Número no encontrado';
  Map<String, dynamic> userData = {};
  static String idCliente = '56977838836';
  bool isLoading = false;
  bool addPuntos = false;

  static const uLocal = 'https://wampus.mclautaro.cl/API';

  // Función para obtener puntos del cliente
  static Future<List<Puntos>> getPuntos(String idCliente) async {
    final url = Uri.parse('$uLocal/puntos?id_cliente=$idCliente');
    print(url);     final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data.map<Puntos>(Puntos.fromJson).toList();
  }

  // Función para obtener datos del cliente
  Future<void> getData() async {
    setState(() {
      msgbusqueda = 'Número no encontrado';
      isLoading = true;
      userData = {};
    });

    try {
      final url =
          Uri.parse('$uLocal/cliente?id_cliente=${phoneNumberController.text}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        if (decodedBody is Map<String, dynamic>) {
          setState(() {
            userData = decodedBody;
            isLoading = false;
            cliente = userData['nombre'];
            idCliente = userData['id_cliente'];
            msgbusqueda = '';
          });
        } else {
          throw Exception('La respuesta no es un JSON válido');
        }
      } else {
        throw Exception('Fallo de Lectura');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // Función para enviar datos del cliente
  Future<void> postData() async {
    setState(() {
      isLoading = true;
      userData = {};
    });

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);

      final url = Uri.parse(
          '$uLocal/puntos?id_cliente=${phoneNumberController.text}&fecha=$formattedDate&hora=$formattedTime&puntos=${puntosNumberController.text}&observacion=Registro_Wampus');  
      final response = await http.post(url);

      if (response.statusCode == 201) {
        _showMessage('PUNTOS GUARDADOS A\n$cliente',
            'Cliente:${phoneNumberController.text}\nFecha: $formattedDate\nHora: $formattedTime\nPuntos:${puntosNumberController.text}\n\tREGISTRO MANUAL');
        final dynamic decodedBody = json.decode(response.body);
        if (decodedBody is Map<String, dynamic>) {
          setState(() {
            userData = decodedBody;
            isLoading = false;
          });
        } else {
          throw Exception('La respuesta no es un JSON válido');
        }
      } else {
        throw Exception('Fallo de Lectura');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color(0xFFfb5104),
            ),
            onPressed: () {},
          ),
        ],
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 147,
                height: 60,
                fit: BoxFit.cover,
              ),
              const Text(
                'Update Wampus',
                textAlign: TextAlign.center,
                style: TextStyle(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: InputDecoration(
                fillColor: Colors.amber,
                focusColor: Colors.amber,
                labelText: 'Número telefónico',
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(14.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(14.0)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getData();
                    addPuntos = true;
                  },
                  child: const Text('Agregar Puntos'),
                ),
                const SizedBox(width: 18.2),
                ElevatedButton(
                  onPressed: () {
                    getData();
                    addPuntos = false;
                  },
                  child: const Text('Obtener Puntos'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                  child: CircularProgressIndicator())
            else if (userData.isNotEmpty && addPuntos)
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 177, 180, 245).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Text('Nombre: ${userData['nombre']}'),
                      Text('Correo: ${userData['correo']}'),
                      Text('Dirección: ${userData['direccion']}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 32.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: puntosNumberController,
                          decoration: InputDecoration(
                            prefixIconColor: Colors.blue,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            filled: true,
                            labelText: 'Número de puntos',
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(14.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(14.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            postData();
                          },
                          child: const Text('Guardar Puntos'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (userData.isNotEmpty && (!addPuntos))
              Expanded(
                child: FutureBuilder<List<Puntos>>(
                    future: getPuntos(idCliente),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final puntos = snapshot.data!;
                        return buildPuntos(puntos);
                      } else {
                        return const Text('No hay datos');
                      }
                    }),
              )
            else if (phoneNumberController.text == '')
              const Text('')
            else
              Text(msgbusqueda),
          ],
        ),
      ),
    );
  }

  // Muestra un mensaje en un diálogo
  void _showMessage(String titulo, String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  // Construye la lista de puntos
  Widget buildPuntos(List<Puntos> puntos) => ListView.builder(
    itemCount: puntos.length,
    itemBuilder: (context, index) {
      final punto = puntos[index];
      return Column(
        children: [
          Card(
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Center(
                        child: Text(
                          punto.puntos.toString(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            punto.obs,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            punto.fecha,
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            punto.hora,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      );
    },
  );
}
