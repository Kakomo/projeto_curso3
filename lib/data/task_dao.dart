import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  //nome do banco de dados
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, ' //aqui eu esqueci uma virgula e ele bugou tudo, e o pior é que pra voltar a funcionar eu tenho de deletar esse banco de dados ou fazer um novo!
      '$_image TEXT, '
      '$_level INTEGER)';

  // nome das variaveis do banco de dados
  //separadamente assim fica mais facil de alterar o banco de dados.

  static const String _tableName = 'tarefas';
  static const String _name = 'nome';
  static const String _difficulty = 'dificuldade';
  static const String _image = 'imagem';
  static const String _level = 'nivel';

  save(Task tarefa) async {
    //abre o banco de dados no caminho que está no sistema,
    // com o nome que definimos
    final Database bancoDeDados = await getDatabase();
    print('Banco de dados encontrado em: $bancoDeDados');

    //procura a tarefa
    var itemExists = await find(tarefa.nome);
    print('Tarefa encontrada${itemExists}');
    //transforma a informação em um mapa

    //ruim
    // Map<String, dynamic> taskMap(Task tarefa) {
    //   final Map<String, dynamic> mapaDeTarefas = Map();
    //   mapaDeTarefas[_name] = tarefa.nome;
    //   mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    //   mapaDeTarefas[_image] = tarefa.foto;
    //   return mapaDeTarefas;
    // bom porque estara fora do save, pode ser reutilizado
    Map<String, dynamic> taskMap = _toMap(tarefa);
    print('Mapa criado: $taskMap');

    if (itemExists.isEmpty) {
      print('a Tarefa não existia: $taskMap');
      // se não existir ( tamanho é zero ), adicione novo nome.
      return await bancoDeDados.insert(
          _tableName, taskMap); // só aceita mapas com String
    } else {
      //se existir, altere tudo baseado no nome!
      print('a Tarefa existia: $taskMap');
      return await bancoDeDados.update(_tableName, taskMap,
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }
  }

  Future<List<Task>> findAll() async {
    print('Acessando findAll: ');
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result =
        await bancoDeDados.query(_tableName);
    print('Procurando dados no banco de dados... encontrado :$result');
    return _toList(result);
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando find: ');
    final Database bancoDeDados = await getDatabase();
    print('Procurando tarefa com o nome: ${nomeDaTarefa}');
    final List<Map<String, dynamic>> result = await bancoDeDados
        .query(_tableName, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    print('Tarefa encontrada: ${_toList(result)}');

    return _toList(result);
  }

  delete(String nomeDaTarefa) async {
    print('Deletando tarefa: $nomeDaTarefa');
    final Database bancoDeDados = await getDatabase();
    return await bancoDeDados
        .delete(_tableName, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
  }

  List<Task> _toList(List<Map<String, dynamic>> listaDeTarefa) {
    print('Convertendo to List: ');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in listaDeTarefa) {
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty],
          linha[_level]); // tudo porque o DB não aceita o tipo int.
      tarefas.add(tarefa);
    }
    print('Lista de Tarefas: $tarefas');
    return tarefas;
  }

  Map<String, dynamic> _toMap(Task tarefa) {
    print('Convertendo to Map: ');
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    mapaDeTarefas[_level] = tarefa.nivel;
    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }
}
