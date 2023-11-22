import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'basedatos.dart';

class Prac02 extends StatefulWidget {
  const Prac02({super.key});

  @override
  State<Prac02> createState() => _Prac02State();
}

class _Prac02State extends State<Prac02> {
  int _index = 0;
  int pos = 1;
  String titul = "L I B R E R I A  C E L I A";
  String subtitulo = "I N S E R T A R  L I B R O";
  final titulo = TextEditingController();
  final autor = TextEditingController();
  final isbn = TextEditingController();
  final editorial = TextEditingController();
  final anoPubli = TextEditingController();
  final genero = TextEditingController();
  final numPag = TextEditingController();

  List<String> img = ["l1.jpg","l2.jpg","l3.jpg","l4.jpg","l5.jpg","l6.jpg"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("${titul}", style:
        TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        elevation: 0,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.brown.shade300,
            child: Text(
              "LC",
              style: TextStyle(fontSize: 25, color: Colors.white54),
            ),
          )
        ],
      ),
      body: dinamico(),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.brown,
          color: Colors.brown.shade200,
          animationDuration: Duration(milliseconds: 200),
          items: [
            Icon(Icons.home_filled, color: Colors.white,),
            Icon(Icons.add, color: Colors.white,)
          ],
        onTap: (indice){
            setState(() {
              _index = indice;
            });
        }
      )
    );
  }

  Widget dinamico(){
    switch(_index){
      case 1: return capturar();
    }
    return inicio();
  }//dinamico()

  Widget inicio(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]['titulo']}"),
                    subtitle: Text("${listaJSON.data?[indice]['autor']}"),
                    trailing: IconButton(onPressed: (){
                      DB.eliminar(listaJSON.data?[indice]['id'])
                          .then((value) {
                        setState(() {
                          titul = "L I B R O  E L I M I N A D O";
                        });
                      });
                    }, icon: Icon(Icons.delete)),
                    onTap: (){
                      String IDlibro = listaJSON.data?[indice]['id'];
                      actualizar(IDlibro);
                    },
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget capturar(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text("${subtitulo}",
          style:
          TextStyle(
            fontSize:  18,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade200,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5,),
        TextField(
          controller: titulo,
          decoration: InputDecoration(
              labelText: "Titulo:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: autor,
          decoration: InputDecoration(
              labelText: "Autor:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: isbn,
          decoration: InputDecoration(
              labelText: "ISBN:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: editorial,
          decoration: InputDecoration(
              labelText: "Editorial:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: anoPubli,
          decoration: InputDecoration(
              labelText: "Año publicación:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: genero,
          decoration: InputDecoration(
              labelText: "Genero:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: numPag,
          decoration: InputDecoration(
              labelText: "Número páginas:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        FilledButton(
            onPressed: (){
              var basedatos = FirebaseFirestore.instance;

              basedatos.collection("libros").add({
                'titulo': titulo.text,
                'autor':autor.text,
                'isbn': isbn.text,
                'editorial': editorial.text,
                'anoPubli': anoPubli.text,
                'genero':genero.text,
                'numPag': int.parse(numPag.text),
              }).then((value){
                setState(() {
                  titul = "L I B R O  I N S E R T A D O";
                });
                titulo.text = "";
                autor.text = "";
                isbn.text = "";
                editorial.text = "";
                anoPubli.text = "";
                genero.text = "";
                numPag.text = "";
              });
            },
            child: const Text("ACEPTAR")
        )
      ],
    );
  }

  void actualizar(String ID) async{
    final titulo = TextEditingController();
    final autor = TextEditingController();
    final isbn = TextEditingController();
    final editorial = TextEditingController();
    final anoPubli = TextEditingController();
    final genero = TextEditingController();
    final numPag = TextEditingController();

    var datosLibro = await DB.mostrarLibro(ID);
    if (datosLibro.isNotEmpty) {
      setState(() {
        titulo.text = datosLibro['titulo'];
        autor.text = datosLibro['autor'];
        isbn.text = datosLibro['isbn'];
        editorial.text = datosLibro['editorial'];
        anoPubli.text = datosLibro['anoPubli'];
        genero.text = datosLibro['genero'];
        numPag.text = datosLibro['numPag'].toString();
      });
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom+50
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("ID: ${ID}", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                TextField(
                  controller: titulo,
                  decoration: InputDecoration(
                      labelText: "Titulo:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: autor,
                  decoration: InputDecoration(
                      labelText: "Autor:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: isbn,
                  decoration: InputDecoration(
                      labelText: "ISBN:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: editorial,
                  decoration: InputDecoration(
                      labelText: "Editorial:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: anoPubli,
                  decoration: InputDecoration(
                      labelText: "Año publicación:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: genero,
                  decoration: InputDecoration(
                      labelText: "Genero:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: numPag,
                  decoration: InputDecoration(
                      labelText: "Número páginas:"
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          var JSonTemporal={
                            'id': ID,
                            'titulo': titulo.text,
                            'autor':autor.text,
                            'isbn': isbn.text,
                            'editorial': editorial.text,
                            'anoPubli': anoPubli.text,
                            'genero':genero.text,
                            'numPag': int.parse(numPag.text),
                          };
                          DB.actualizar(JSonTemporal).then((value) {
                            setState(() {
                              titul = "L I B R O  A C T U A L I Z A  D O";
                              Navigator.pop(context);
                            });
                          });
                          titulo.clear();
                          autor.clear();
                          isbn.clear();
                          editorial.clear();
                          anoPubli.clear();
                          genero.clear();
                          numPag.clear();
                        },
                        child: Text("ACTUALIZAR")
                    ),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("CANCELAR")
                    ),
                  ],
                )

              ],
            ),
          );
        }
    );
  }

}
