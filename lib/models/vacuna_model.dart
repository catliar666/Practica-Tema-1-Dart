// To parse this JSON data, do
//
//     final vacuna = vacunaFromJson(jsonString);

import 'dart:convert';
import 'package:time_machine/time_machine.dart';

Vacuna vacunaFromJson(String str) => Vacuna.fromJson(json.decode(str));

String vacunaToJson(Vacuna data) => json.encode(data.toJson());

class Vacuna {
  String? id;
  String dniPaciente;
  DateTime fechaInoculacion;
  int idMedico;
  int lote;
  String nombre;

  Vacuna({
    required this.dniPaciente,
    required this.fechaInoculacion,
    required this.idMedico,
    required this.lote,
    required this.nombre,
  });

  factory Vacuna.fromJson(Map<String, dynamic> json) => Vacuna(
        dniPaciente: json["dniPaciente"],
        fechaInoculacion: DateTime.parse(json["fechaInoculacion"]),
        idMedico: json["idMedico"],
        lote: json["lote"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "dniPaciente": dniPaciente,
        "fechaInoculacion": fechaInoculacion.toString(),
        "idMedico": idMedico,
        "lote": lote,
        "nombre": nombre,
      };

  
}
