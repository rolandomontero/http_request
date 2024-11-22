import 'package:clubwampus/global/const.dart';
import 'package:clubwampus/model/premio.dart';
import 'package:clubwampus/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPremios extends StatefulWidget {
  final Function(String) cobraPremio;

  const ListPremios({super.key, required this.cobraPremio});

  @override
  State<ListPremios> createState() => _ListPremiosState();
}

class _ListPremiosState extends State<ListPremios> {
  List<Premio> _premios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _premios = await AuthMethod.getPremios();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  : _premios.isEmpty
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
                            itemCount: _premios.length,
                            itemBuilder: (context, index) {
                              final premio = _premios[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                elevation: 2.0,
                                child: ListTile(
                                  leading: const SizedBox(
                                    child: Text('🛎️',
                                        style: TextStyle(
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.bold)),
                                  ), // Placeholder si no hay imagen
                                  title: Row(
                                    children: [
                                      Text(
                                        premio.categoria,
                                        style: GoogleFonts.acme(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${premio.puntos} p',
                                        style: GoogleFonts.acme(
                                            color: txt_wampus,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                  subtitle: Text(
                                    premio.promo,
                                    style: GoogleFonts.acme(fontSize: 16.0),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () {
                                    widget.cobraPremio(
                                        'Cobrar premio ${premio.promo}ptos');
                                  },
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
