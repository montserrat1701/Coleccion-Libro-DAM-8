import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> libros) async{
    return await baseRemota.collection("libros").add(libros); //then se hace en la vista para el usuario
  }

  static Future<List> mostrarTodos() async{
    List temporal = [];
    var query = await baseRemota.collection("libros").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dataTemp = element.data();
      dataTemp.addAll({'id':element.id});
      temporal.add(dataTemp);
    });
    return temporal;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("libros")
        .doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> libros) async{
    String idActualizar = libros['id'];
    libros.remove('id');
    return await baseRemota.collection("libros")
        .doc(idActualizar).update(libros);
  }

  static Future<Map<String, dynamic>> mostrarLibro(String id) async {
    var doc = await baseRemota.collection("libro").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      data.addAll({'id': doc.id});
      return data;
    } else {
      return {};
    }
  }
}