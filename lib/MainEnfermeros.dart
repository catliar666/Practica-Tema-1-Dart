import 'dart:io';
import 'package:practicatema1/models/paciente_model.dart';
import 'package:practicatema1/models/vacuna_model.dart';
import 'package:practicatema1/services/paciente_service.dart';
import 'package:practicatema1/services/vacuna_service.dart';

Future<void> main() async {
  PacienteService pacienteService = PacienteService();
  VacunaService vacunaService = VacunaService();
  do {
    await menuVacunacion(pacienteService, vacunaService);
  } while (true);
}

Future<void> menuVacunacion(
    PacienteService pacienteService, VacunaService vacunaService) async {
  print('Introduce el dni del paciente: ');
  String dni = stdin.readLineSync() ?? '';

  Paciente? paciente = await pacienteService.getPaciente(dni);

  if (paciente == null) {
    await registraPaciente(dni, pacienteService, vacunaService);
  } else {
    // Llama a registraVacuna y espera su resultado
    bool vacunado = await registraVacuna(dni, vacunaService);
    if (vacunado) {
      print(
          '''
***********************
Vacunado correctamente
***********************
'''); // Este mensaje ahora se mostrará si se vacuna
    } else {
      print('''
**********************************
Error al registrar la vacunación.
**********************************
''');
    }
  }
}

Future<void> registraPaciente(String dni, PacienteService pacienteService,
    VacunaService vacunaService) async {
  print('Introduce el nombre completo del paciente: ');
  String nombreCompleto = stdin.readLineSync() ?? '';

  // Crear objeto Paciente
  Paciente pacienteInsertar =
      Paciente(dni: dni, nombreCompleto: nombreCompleto);

  // Registrar paciente y comprobar si fue exitoso
  String? id = await pacienteService.postPaciente(pacienteInsertar);

  if (id != null) {
    // Registramos la vacuna y verificamos el resultado
    bool registrado = await registraVacuna(dni, vacunaService);

    if (registrado) {
      print('''
***********************
Vacunado correctamente
***********************''');
    } else {
      print('''
*****************************************
Ha ocurrido un fallo al guardar los datos
*****************************************
''');
    }
  } else {
    print('''
******************************************
Ha ocurrido un fallo al guardar los datos
******************************************
''');
  }
}

Future<bool> registraVacuna(String dni, VacunaService vacunaService) async {
  print('Nombre de la vacuna: ');
  String nombre = stdin.readLineSync() ?? '';

  int lote = -1;
  int idMedico = -1;

  do {
    print('Número de lote: ');
    String? inputLote = stdin.readLineSync();
    lote = int.tryParse(inputLote ?? '') ?? -1;

    if (lote == -1) {
      print('''
********************************************
Número de lote no válido. Intenta de nuevo.
********************************************''');
    }
  } while (lote == -1);

  do {
    print('Id del profesional que ha vacunado: ');
    String? inputMedico = stdin.readLineSync();
    idMedico = int.tryParse(inputMedico ?? '') ?? -1;

    if (idMedico== -1) {
      print('''
********************************************
Número de lote no válido. Intenta de nuevo.
********************************************
''');
    }
  } while (idMedico == -1);

  Vacuna vacunaNueva = Vacuna(
      dniPaciente: dni,
      fechaInoculacion: DateTime.now(),
      idMedico: idMedico,
      lote: lote,
      nombre: nombre);

  String? idVacuna = await vacunaService.postVacuna(vacunaNueva);

  if (idVacuna != null) {
    vacunaNueva.id = idVacuna;
    return true; // Retorna true si se registró correctamente
  } else {
    return false; // Retorna false si hubo un error
  }
}
