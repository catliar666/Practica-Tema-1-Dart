import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:practicatema1/models/paciente_model.dart';
import 'package:http/http.dart';
import 'package:practicatema1/models/vacuna_model.dart';

class VacunaService {
  String _url =
      'https://vacunacion-covid-f0811-default-rtdb.europe-west1.firebasedatabase.app/Vacuna';

  Future<List<Vacuna>> getVacunas() async {
    List<Vacuna> vacunas = [];
    Uri uri = Uri.parse('$_url.json');
    Response response = await get(uri);
    Map<String, dynamic> firebase = jsonDecode(response.body);
    firebase.forEach((clave, valor) {
      Vacuna temp = Vacuna.fromJson(valor);
      temp.id = clave;
      vacunas.add(temp);
    });
    return vacunas;
  }

  Future<List<Vacuna>> getVacunasByDni(String dni) async {
    List<Vacuna> vacunasPaciente = [];
    List<Vacuna> vacunas = await getVacunas();
    for (int i = 0; i < vacunas.length; i++) {
      if (vacunas[i].dniPaciente == dni) vacunasPaciente.add(vacunas[i]);
    }
    return vacunasPaciente;
  }

  Future<Vacuna?> getVacuna(int lote) async {
    Vacuna? vacunaEncontrado;
    List<Vacuna> vacunas = await getVacunas();
    for (int i = 0; i < vacunas.length; i++) {
      if (vacunas[i].lote == lote) vacunaEncontrado = vacunas[i];
    }
    return vacunaEncontrado;
  }

  Future<String> postVacuna(Vacuna v) async {
    Uri uri = Uri.parse('$_url.json');
    String vacunaString = jsonEncode(v);
    Response response = await post(uri, body: vacunaString);
    return jsonDecode(response.body)['name'];
  }

  String obtieneCertificado(List<Vacuna> vacunas) {
    if (vacunas.isEmpty)
      return 'No tiene vacunas administradas';
    else {
      if (vacunas.length < 2) {
        return '''
                *************************************************
                USTED NO PUEDE OBTENER EL CERTIFICADO COVID
                *************************************************
                ''';
      } else {
        return '''
                *******************************************************
                ESTAS TOTALMENTE VACUNADO, HAS OBTENIDO EL CERTIFICADO
                *******************************************************
                ''';
      }
    }
  }

  String? muestraVacunas(List<Vacuna> vacunas) {
    String fechaFormateada;
    String resultado = '';
    if (!vacunas.isEmpty) {
      vacunas.forEach((vacuna) => {
        fechaFormateada = DateFormat('dd/MM/yyyy').format(vacuna.fechaInoculacion),
            resultado += '''
              -Nombre de la vacuna: ${vacuna.nombre}
              -Número de lote: ${vacuna.lote}
              -Fecha de la inoculación: ${fechaFormateada}
              **********************************************\n'''
          });
      return resultado;
    }
  }
}
