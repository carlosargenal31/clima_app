class DatosClima {
  late ClimaActual actual;
  late List<Pronostico> pronostico;

  DatosClima({required this.actual, required this.pronostico});

  DatosClima.fromJson(Map<String, dynamic> json) {
    actual = ClimaActual.fromJson(json['current']);
    pronostico = (json['forecast']['forecastday'] as List<dynamic>?)
            ?.map((x) => Pronostico.fromJson(x))
            .toList() ??
        [];
  }
}

class ClimaActual {
  late double tempC;
  late Condicion condicion;
  late double velocidadVientoKph;
  late int humedad;
  late double presionMb;
  late double visibilidadKm;
  late double uv;

  ClimaActual({
    required this.tempC,
    required this.condicion,
    required this.velocidadVientoKph,
    required this.humedad,
    required this.presionMb,
    required this.visibilidadKm,
    required this.uv,
  });

  ClimaActual.fromJson(Map<String, dynamic> json) {
    tempC = json['temp_c'];
    condicion = Condicion.fromJson(json['condition']);
    velocidadVientoKph = json['wind_kph'];
    humedad = json['humidity'];
    presionMb = json['pressure_mb'];
    visibilidadKm = json['vis_km'];
    uv = json['uv'];
  }
}

class Condicion {
  late String texto;

  Condicion({required this.texto});

  Condicion.fromJson(Map<String, dynamic> json) {
    texto = json['text'];
  }
}

class Pronostico {
  late String fecha;
  late double tempMin;
  late double tempMax;
  late Condicion condicion;

  Pronostico({
    required this.fecha,
    required this.tempMin,
    required this.tempMax,
    required this.condicion,
  });

  Pronostico.fromJson(Map<String, dynamic> json) {
    fecha = json['date'];
    tempMin = json['day']['mintemp_c'];
    tempMax = json['day']['maxtemp_c'];
    condicion = Condicion.fromJson(json['day']['condition']);
  }
}
