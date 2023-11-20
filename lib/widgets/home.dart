import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clima_app/clases/clima.dart';

class MiPaginaPrincipal extends StatefulWidget {
  @override
  _MiPaginaPrincipalState createState() => _MiPaginaPrincipalState();
}

class _MiPaginaPrincipalState extends State<MiPaginaPrincipal> {
  final Map<String, String> departamentosHonduras = {
    "Atlántida": "La Ceiba",
    "Choluteca": "Choluteca",
    "Colón": "Trujillo",
    "Comayagua": "Comayagua",
    "Copán": "Santa Rosa de Copán",
    "Cortés": "San Pedro Sula",
    "El Paraíso": "Yuscarán",
    "Francisco Morazán": "Tegucigalpa",
    "Gracias a Dios": "Puerto Lempira",
    "Intibucá": "La Esperanza",
    "Islas de la Bahía": "Roatán",
    "La Paz": "La Paz",
    "Lempira": "Gracias",
    "Ocotepeque": "Nueva Ocotepeque",
    "Olancho": "Juticalpa",
    "Santa Bárbara": "Santa Bárbara",
    "Valle": "Nacaome",
    "Yoro": "Yoro",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App del Clima - Departamentos de Honduras"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Actualizar toda la lista
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: departamentosHonduras.length,
        itemBuilder: (context, index) {
          final departamento = departamentosHonduras.keys.elementAt(index);
          final capital = departamentosHonduras[departamento]!;
          return TarjetaClimaCiudad(
            departamento: departamento,
            capital: capital,
          );
        },
      ),
    );
  }
}

class TarjetaClimaCiudad extends StatefulWidget {
  final String departamento;
  final String capital;

  TarjetaClimaCiudad({required this.departamento, required this.capital});

  @override
  _EstadoTarjetaClimaCiudad createState() => _EstadoTarjetaClimaCiudad();
}

class _EstadoTarjetaClimaCiudad extends State<TarjetaClimaCiudad> {
  late Future<DatosClima> datosClimaFuturo;

  @override
  void initState() {
    super.initState();
    datosClimaFuturo = obtenerDatosClima(widget.capital);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      child: ListTile(
        title: Text("${widget.departamento} - ${widget.capital}"),
        subtitle: FutureBuilder(
          future: datosClimaFuturo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Cargando...");
            } else if (snapshot.hasData) {
              final datosClima = snapshot.data as DatosClima;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Temperatura: ${datosClima.actual.tempC}°C"),
                  Text("Condiciones: ${datosClima.actual.condicion.texto}"),
                  Text(
                      "Velocidad del Viento: ${datosClima.actual.velocidadVientoKph} km/h"),
                  SizedBox(height: 10),
                  Text("Pronóstico para los próximos días:"),
                  ...construirPronostico(datosClima.pronostico),
                ],
              );
            } else {
              return const Text("No hay datos disponibles");
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaClimaCiudad(ciudad: widget.capital),
            ),
          );
        },
      ),
    );
  }

  Future<DatosClima> obtenerDatosClima(String ciudad) async {
    var url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=75e76b2ba04b45a5bfe24927232011&q=$ciudad&days=5");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> cuerpo = json.decode(response.body);
    return DatosClima.fromJson(cuerpo);
  }

  List<Widget> construirPronostico(List<Pronostico> pronostico) {
    return pronostico.map((pronosticoDia) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Fecha: ${pronosticoDia.fecha}"),
          Text("Temperatura Mínima: ${pronosticoDia.tempMin}°C"),
          Text("Temperatura Máxima: ${pronosticoDia.tempMax}°C"),
          Text("Condiciones: ${pronosticoDia.condicion.texto}"),
          SizedBox(height: 10),
        ],
      );
    }).toList();
  }
}

class PantallaClimaCiudad extends StatefulWidget {
  final String ciudad;

  PantallaClimaCiudad({required this.ciudad});

  @override
  _EstadoPantallaClimaCiudad createState() => _EstadoPantallaClimaCiudad();
}

class _EstadoPantallaClimaCiudad extends State<PantallaClimaCiudad> {
  late Future<DatosClima> datosClimaFuturo;

  @override
  void initState() {
    super.initState();
    datosClimaFuturo = obtenerDatosClima(widget.ciudad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clima en ${widget.ciudad}"),
      ),
      body: Center(
        child: FutureBuilder(
          future: datosClimaFuturo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final datosClima = snapshot.data as DatosClima;
              return construirInformacionClimatica(datosClima);
            } else {
              return const Text("No hay datos disponibles");
            }
          },
        ),
      ),
    );
  }

  static Future<DatosClima> obtenerDatosClima(String ciudad) async {
    var url = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=75e76b2ba04b45a5bfe24927232011&q=$ciudad");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> cuerpo = json.decode(response.body);
    return DatosClima.fromJson(cuerpo);
  }

  Widget construirInformacionClimatica(DatosClima datosClima) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Temperatura: ${datosClima.actual.tempC}°C"),
        Text("Condiciones: ${datosClima.actual.condicion.texto}"),
        Text(
            "Velocidad del Viento: ${datosClima.actual.velocidadVientoKph} km/h"),
        Text("Humedad: ${datosClima.actual.humedad}%"),
        Text("Presión Atmosférica: ${datosClima.actual.presionMb} mb"),
        Text("Visibilidad: ${datosClima.actual.visibilidadKm} km"),
        Text("Índice UV: ${datosClima.actual.uv}"),
      ],
    );
  }
}
