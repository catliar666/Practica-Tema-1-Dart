import 'dart:developer';
import 'dart:io';
import 'package:practicatema1/models/paciente_model.dart';
import 'package:practicatema1/models/vacuna_model.dart';
import 'package:practicatema1/services/paciente_service.dart';
import 'package:practicatema1/services/vacuna_service.dart';

Future<void> main() async {
  PacienteService pacienteService = PacienteService();
  VacunaService vacunaService = VacunaService();
  do {
    String dni = empiezaMenu();
    Paciente? paciente = await pacienteService.getPaciente(dni);
    if (paciente != null)
      await muestraInformacion(paciente, vacunaService, pacienteService);
    else
      print('''
        *******************************************************
        El dni introducido no existe en nuestras creedenciales
        *******************************************************
    ''');
  } while (true);
}

Future<void> muestraInformacion(Paciente paciente, VacunaService vacunaService,
    PacienteService pacienteService) async {
  List<Vacuna> vacunas = await vacunaService.getVacunasByDni(paciente.dni);
  print(vacunaService.obtieneCertificado(vacunas));
  if (!vacunas.isEmpty) {
    print("""
        **********INFORMACIÓN VACUNAS*************
        """);
    print(vacunaService.muestraVacunas(vacunas));
  }
}

Future<Paciente?> buscaPaciente(
    String dni, PacienteService pacienteService) async {
  return await pacienteService.getPaciente(dni);
}

String empiezaMenu() {
  print("""
  **********MENÚ PRINCIPAL************
  Introduce tu DNI:""");
  return stdin.readLineSync() ?? "Null";
}
