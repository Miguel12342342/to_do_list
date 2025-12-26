import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var list = [
    "Ir ao mercado",
    "Estudar",
    "Test"
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de Tarefaas",style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        itemCount:list.length ,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(list[index]),         
          );
        },
      ),
      floatingActionButton: FloatingActionButton(     
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        elevation: 6,
       // mini: true,
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text("Adicionar Tarefa"),
              content: TextField(
                decoration: InputDecoration(
                  labelText: "Digite sua tarefa"
                ),
                onChanged: (text){

                },
                
              ),
              actions: [
                 TextButton(child:Text("Salvar") ,
                onPressed: () {
                  //salvar
                  
                },
                ),
                TextButton(child:Text("Cancelar") ,
                onPressed: () {
                  Navigator.pop(context);
                },
                ),
               
              ],
              );
          });
        print("Resultado:botão pressionado");
      }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(onPressed: (){

            }, icon: Icon(Icons.menu))
          ],
        ),
      ),
     // bottomNavigationBar:BottomNavigationBar(items: null),
    );
  }
}