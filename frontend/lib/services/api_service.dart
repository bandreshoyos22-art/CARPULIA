import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/viaje.dart';

class ApiService {

  // VPS
  static const String baseUrl =
      'http://143.198.178.182:8000/api';

  final http.Client client;

  ApiService({
    http.Client? client
  }) : client = client ?? http.Client();



  // ==========================
  // VIAJES
  // ==========================

  Future<List<Viaje>> fetchViajes() async {

    final url =
        Uri.parse('$baseUrl/viajes/');

    final response =
        await client
            .get(url)
            .timeout(
              const Duration(seconds:8)
            );

    if(response.statusCode==200){

      final data =
          jsonDecode(response.body)
              as List<dynamic>;

      return data.map((item){

        final viaje =
            Viaje.fromJson(
              item as Map<String,dynamic>
            );

        return viaje.copyWith(
          conductorEmail:
              viaje.conductorEmail
        );

      }).toList();

    }

    return [];

  }



  Future<Viaje?> createViaje(
      Viaje viaje
      ) async {

    try{

      final url =
      Uri.parse(
          '$baseUrl/viajes/'
      );

      final body =
      jsonEncode({

        'vehiculo':
        viaje.vehiculo,

        'conductor_email':
        viaje.conductorEmail,

        'origen':
        viaje.origen,

        'destino':
        viaje.destino,

        'fecha':
        viaje.fecha,

        'hora_salida':
        viaje.horaSalida,

        'cupos_disponibles':
        viaje.cuposDisponibles,

        'precio':
        viaje.precio

      });

      final response =
      await client.post(

        url,

        headers: {

          'Content-Type':
          'application/json'

        },

        body: body,

      );

      if(response.statusCode==201){

        final data=
        jsonDecode(
            response.body
        );

        return Viaje.fromJson(
            data
        );

      }

    }

    catch(_){

      return null;

    }

    return null;

  }



  Future<Viaje?> updateViaje(
      Viaje viaje
      ) async {

    if(viaje.id==null){

      return null;

    }

    try{

      final url=
      Uri.parse(
          '$baseUrl/viajes/${viaje.id}/'
      );

      final body=
      jsonEncode({

        'vehiculo':
        viaje.vehiculo,

        'conductor_email':
        viaje.conductorEmail,

        'origen':
        viaje.origen,

        'destino':
        viaje.destino,

        'fecha':
        viaje.fecha,

        'hora_salida':
        viaje.horaSalida,

        'cupos_disponibles':
        viaje.cuposDisponibles,

        'precio':
        viaje.precio

      });

      final response=
      await client.put(

        url,

        headers:{

          'Content-Type':
          'application/json'

        },

        body: body,

      );

      if(response.statusCode==200){

        final data=
        jsonDecode(
            response.body
        );

        return Viaje.fromJson(
            data
        );

      }

    }

    catch(_){

      return null;

    }

    return null;

  }



  // ==========================
  // REGISTRO
  // ==========================

  Future<void> register({

    required String username,

    required String email,

    required String password,

    required String universidad,

    required String carrera,

    required String direccion,

  }) async {

    final url=
    Uri.parse(
        '$baseUrl/register/'
    );

    final response=
    await client.post(

      url,

      headers:{

        'Content-Type':
        'application/json'

      },

      body:jsonEncode({

        'username':
        username,

        'email':
        email,

        'password':
        password,

        'universidad':
        universidad,

        'carrera':
        carrera,

        'direccion_residencia':
        direccion,

      }),

    );

    if(response.statusCode!=201){

      throw Exception(
          'Error registrando usuario'
      );

    }

  }

}
