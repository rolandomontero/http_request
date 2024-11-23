import 'package:http_request/global/const.dart';
import 'package:http_request/model/puntos.dart';
import 'package:http_request/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListVisitas extends StatefulWidget {
  final String idCliente;

  const ListVisitas({super.key, required this.idCliente});

  @override
  State<ListVisitas> createState() => _ListVisitasState();
}

class _ListVisitasState extends State<ListVisitas> {
  List<Puntos> _puntos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _puntos = await AuthMethod.getPuntos(widget.idCliente);
    setState(() {
      _isLoading = false;
    });
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
     
      body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wallpapers/fondo-main.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Lista de Premios',
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                    color: txt_wampus,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _puntos.isEmpty
                      ? Center(
                          child: Text(
                            'No hay premios disponibles',
                            style: GoogleFonts.acme(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _puntos.length,
                            itemBuilder: (context, index) {
                              final puntos = _puntos[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                elevation: 2.0,
                                child: ListTile(
                                  leading: const SizedBox(
                                    child: Text('👉',
                                        style: TextStyle(
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.bold)),
                                  ), // Placeholder si no hay imagen
                                  title: Row(
                                    children: [
                                      Text(
                                        puntos.fecha,
                                        style: GoogleFonts.acme(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${puntos.puntos} p',
                                        style: GoogleFonts.acme(
                                            color: txt_wampus,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                  subtitle: Text(
                                    puntos.observacion,
                                    style: GoogleFonts.acme(fontSize: 16.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
            ],
          )),
    );
  }
}
