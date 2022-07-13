import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          )
        ],
        title: const Text('Tarefas'),
      ),

      //estudar mais o FutureBuilder
      body: FutureBuilder<List<Task>>(
        future: TaskDao().findAll(),
        builder: (context, snapshot) {
          List<Task>? itens = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('Carregando')],
                ),
              );
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('Carregando')],
                ),
              );

            case ConnectionState.done:
              if (snapshot.hasData && itens != null) {
                if (itens.isNotEmpty) {
                  return ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Task tarefa = itens[index];
                      print('Tarefa $index -> ${tarefa.nome}');
                      return tarefa;
                    },
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(Icons.error_outline,size: 128,), Text('Não há nenhuma Tarefa',style: TextStyle(fontSize: 32),)],
                  ),
                );
              }
              return Text('Erro ao carregar tarefas');
          }
          return Text('Erro');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormScreen(
                taskContext: context,
              ),
            ),
          ).then(// quando sair da tela de Formulário, reconstruir a tela!
            (value) => setState(() {}),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
