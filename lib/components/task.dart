import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/difficulty.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';

class Task extends StatefulWidget {
  final String nome;
  final String foto;
  final int dificuldade;
  int nivel;

  Task(this.nome, this.foto, this.dificuldade, [this.nivel = 0, Key? key]) // para podermos salvar os dados do nível precisamos passar ele como parametro opcional. Não serve o {}
      : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.blue),
            height: 140,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                      width: 72,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.foto,
                          fit: BoxFit.cover,
                          //adicionado para caso não tenha imagem válida no banco de dados!
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/nophoto.png');
                          },
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 200,
                            child: Text(
                              widget.nome,
                              style: const TextStyle(
                                fontSize: 24,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        Difficulty(
                          dificultyLevel: widget.dificuldade,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 52,
                      width: 52,
                      child: ElevatedButton(
                        //onLongPress para deletar uma tarefa!
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(//novo Widget para confirmar se iremos deletar de fato
                                    title: Row(
                                      children: const [
                                        Text('Deletar'),
                                        Icon(Icons.delete_forever),
                                      ],
                                    ),
                                    content: Text('Tem certeza de que deseja deletar essa Tarefa?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {Navigator.pop(context);},
                                        child: Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          await TaskDao().delete(widget.nome);
                                          // print('Tarefa ${widget.nome} deletada');
                                          Navigator.pop(context); // aqui não conseguimos forçar um setState a acontecer lá na tela inicial. Para resolver isso precisamos de um bom gerenciamento de estado.
                                        },
                                        child: Text('Sim'),
                                      ),
                                    ],
                                  );
                                });

                          },
                          onPressed: () {
                            setState(() {
                              widget.nivel++;
                            });
                            print(widget.nivel);
                            TaskDao().save(
                              Task(widget.nome, widget.foto, widget.dificuldade,
                                  widget.nivel),
                            );
                            print(widget.nivel);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Icon(Icons.arrow_drop_up),
                              Text(
                                'UP',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        value: (widget.dificuldade > 0)
                            ? (widget.nivel / widget.dificuldade) / 10
                            : 1,
                      ),
                      width: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Nivel: ${widget.nivel}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
