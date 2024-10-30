import 'dart:convert';

import 'package:practicatema1/models/paciente_model.dart';
import 'package:http/http.dart';

class PacienteService {
  String _url =
      "https://vacunacion-covid-f0811-default-rtdb.europe-west1.firebasedatabase.app/Paciente";

  Future<List<Paciente>> getPacientes() async {
    List<Paciente> pacientes = [];
    Uri uri = Uri.parse('$_url.json');
    Response response = await get(uri);
    Map<String, dynamic> firebase = jsonDecode(response.body);
    firebase.forEach((clave, valor) {
      Paciente temp = Paciente.fromJson(valor);
      temp.id = clave;
      pacientes.add(temp);
    });
    return pacientes;
  }

  Future<Paciente?> getPaciente(String dni) async {
    Paciente? pacienteEncontrado;
    List<Paciente> pacientes = await getPacientes();
    for (int i = 0; i < pacientes.length; i++) {
      if (pacientes[i].dni == dni) pacienteEncontrado = pacientes[i];
    }
    return pacienteEncontrado;
  }

  Future<String> postPaciente(Paciente p) async {
    Uri uri = Uri.parse('$_url.json');
    String pacienteString = jsonEncode(p);
    Response response = await post(uri, body: pacienteString);
    return jsonDecode(response.body)['name'];
  }
}
