import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  Map <String, dynamic> _ultimaTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

 Future <File> _getFile()async{

    final source = await getApplicationDocumentsDirectory();
    String path = source.path;
    return File('$path/data.json');
  }

  _salvarTarefa(){

    String textoDigitado= _controllerTarefa.text;

     Map<String,dynamic> tarefa = Map();
  tarefa["titulo"]= textoDigitado;
  tarefa["realizada"] = false;

  setState(() {
    _listaTarefas.add(tarefa);
  });
  // salva o arquivo em salvar tarefa...
  _salvarArquivo();
_controllerTarefa.text = "";
  }

  _salvarArquivo()async{

    var arquivo = await _getFile();
  //Criar dados
    String dados = jsonEncode(_listaTarefas);
   await arquivo.writeAsString(dados);
    
  }

  Future<String?> lerArquivo() async{

    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }

  }

 @override
void initState() {
  super.initState();

  lerArquivo().then((dados) {
    if (dados != null && dados.isNotEmpty) { // Adicione esta verificação
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    }
  });
}

Widget criarItemLista(context, index){

  final item = _listaTarefas[index]["titulo"] + DateTime.now().millisecondsSinceEpoch.toString();

return  Dismissible(
  // Use uma Key única para evitar que o Flutter se confunda com os índices
  key: Key(item), 
  onDismissed: (direction) {
    // 1. Primeiro, salvamos a tarefa para o caso de "Desfazer"
    _ultimaTarefaRemovida = _listaTarefas[index];
    
    // 2. ESSENCIAL: A remoção DEVE estar dentro do setState
    setState(() {
      _listaTarefas.removeAt(index); 
    });
    
    // 3. Salva a alteração no arquivo (agora que a lista foi atualizada)
    _salvarArquivo();

    ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Limpa avisos anteriores
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa removida!"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            // 4. Para desfazer, inserimos e chamamos o setState novamente
            setState(() {
              _listaTarefas.insert(index, _ultimaTarefaRemovida);
            });
            _salvarArquivo();
          },
        ),
      ),
    );
  },
  direction: DismissDirection.endToStart,
  background: Container(
    color: Colors.red,
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.delete, color: Colors.white),
      ],
    ),
  ),
  child: CheckboxListTile(
    title: Text(_listaTarefas[index]["titulo"]),
    value: _listaTarefas[index]["realizada"],
    onChanged: (valorAlterado) {
      setState(() {
        _listaTarefas[index]["realizada"] = valorAlterado;
      });
      _salvarArquivo();
    },
  ),
);

}


  @override
  Widget build(BuildContext context) {

    _salvarArquivo();
    print("itens:" +_listaTarefas.toString());

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de Tarefas",style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        itemCount:_listaTarefas.length ,
        itemBuilder: criarItemLista
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
                controller: _controllerTarefa,
                decoration: InputDecoration(
                  labelText: "Digite sua tarefa"
                ),
                onChanged: (text){

                },
                
              ),
              actions: [                
                TextButton(child:Text("Cancelar") ,
                onPressed: () {
                  Navigator.pop(context);
                },
                ),
                TextButton(child:Text("Salvar") ,
                onPressed: () {
                  //salvar
                  _salvarTarefa();
                  Navigator.pop(context);
                },
                ),
               
              ],
              );
          });
        print("Resultado:botão pressionado");
      }),
     // bottomNavigationBar:BottomNavigationBar(items: null),
    );
  }
}