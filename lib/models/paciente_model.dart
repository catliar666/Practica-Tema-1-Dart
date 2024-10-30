// To parse this JSON data, do
//
//     final paciente = pacienteFromJson(jsonString);

import 'dart:convert';

Paciente pacienteFromJson(String str) => Paciente.fromJson(json.decode(str));

String pacienteToJson(Paciente data) => json.encode(data.toJson());

class Paciente {
  String? id;
  String dni;
  String nombreCompleto;
  

  Paciente({required this.dni, required this.nombreCompleto});

  factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
        dni: json["DNI"],
        nombreCompleto: json["nombreCompleto"],
      );

  Map<String, dynamic> toJson() => {
        "DNI": dni,
        "nombreCompleto": nombreCompleto,
      };
}
