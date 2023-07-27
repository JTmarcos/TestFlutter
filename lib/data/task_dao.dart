import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/components/tasks.dart';
import 'package:test/data/database.dart';

class TaskDao {
  static const String tableSQL = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_level INTEGER DEFAULT 0, '
      '$_image TEXT)';

  static const String _tablename = 'tasktable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';
  static const String _level = 'level';




//Save----------------------------------------------------------------------------------------------------------------------
   save(Task tarefa) async {
    debugPrint('Iniciando o save: ');
    final Database bancoDeDados = await getDataBase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      debugPrint('a Tarefa não Existia.');
      return await bancoDeDados.insert(_tablename, taskMap);
    } else {
      debugPrint('a Tarefa existia!');
      return await bancoDeDados.update(
        _tablename,
        taskMap,
        where: '$_name = ?',
        whereArgs: [tarefa.nome],
      );
    }
  }

  Map<String, dynamic> toMap(Task tarefa) {
    debugPrint('Convertendo to Map: ');
    final Map<String, dynamic> mapaDeTarefas = {};
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    debugPrint('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    debugPrint('Acessando o findAll: ');
    final Database bancoDeDados = await getDataBase();
    final List<Map<String, dynamic>> result =
        await bancoDeDados.query(_tablename);
    debugPrint('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    debugPrint('Convertendo to List:');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa = Task(
        linha[_name],
        linha[_image],
        linha[_difficulty],
      );
      tarefas.add(tarefa);
    }
    debugPrint('Lista de Tarefas: ${tarefas.toString()}');
    return tarefas;
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    debugPrint('Acessando find: ');
    final Database bancoDeDados = await getDataBase();
    debugPrint('Procurando tarefa com o nome: nomeDaTarefa');
    final List<Map<String, dynamic>> result = await bancoDeDados
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    debugPrint('Tarefa encontrada: ${toList(result)}');

    return toList(result);
  }

  

  delete(String nomeDaTarefa) async {
    debugPrint('Deletando tarefa: $nomeDaTarefa');
    final Database bancoDeDados = await getDataBase();
    return await bancoDeDados.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
  }
}
