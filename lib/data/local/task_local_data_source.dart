import 'dart:convert';

import 'package:challenges_taski/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLocalDataSource {
  static const String _tasksKey = 'tasks';
  static const String _doneTasksKey = 'done_tasks';

  final SharedPreferences sharedPreferences;

  TaskLocalDataSource({required this.sharedPreferences});

  Future<void> cacheTasks(List<Task> tasks) async {
    if (tasks.isNotEmpty) {
      List<String> tasksJson =
          tasks.map((task) => jsonEncode(task.toFullMap())).toList();

      await sharedPreferences.setStringList(_tasksKey, tasksJson);
    }
  }

  Future<void> cacheDoneTasks(List<Task> tasks) async {
    if (tasks.isNotEmpty) {
      List<String> tasksJson =
          tasks.map((task) => jsonEncode(task.toFullMap())).toList();

      await sharedPreferences.setStringList(_doneTasksKey, tasksJson);
    }
  }

  Future<List<Task>> getCachedTasks() async {
    List<String>? tasksJson = sharedPreferences.getStringList(_tasksKey);

    if (tasksJson == null || tasksJson.isEmpty) {
      return [];
    }

    List<Task> tasks = tasksJson
        .map((taskJson) => Task.fromMap(jsonDecode(taskJson)))
        .toList();

    return tasks;
  }

  Future<List<Task>> getCachedDoneTasks() async {
    List<String>? tasksJson = sharedPreferences.getStringList(_doneTasksKey);

    if (tasksJson == null || tasksJson.isEmpty) {
      return [];
    }

    List<Task> tasks = tasksJson
        .map((taskJson) => Task.fromMap(jsonDecode(taskJson)))
        .toList();

    tasks = tasks.where((task) => !task.isDeleted).toList();

    return tasks;
  }

  Future<void> addTask(Task task) async {
    List<Task> currentTasks = await getCachedTasks();
    currentTasks.add(task);

    await cacheTasks(currentTasks);
  }

  Future<void> updateTask(String? idLocal, Task updatedTask) async {
    List<Task> currentTasks = await getCachedTasks();

    Task? taskToUpdate;
    int? taskIndex;

    bool isRemoteTask = updatedTask.idLocal == null;

    for (int i = 0; i < currentTasks.length; i++) {
      Task task = currentTasks[i];
      if ((isRemoteTask && task.id == updatedTask.id) ||
          (!isRemoteTask && task.idLocal == idLocal)) {
        taskToUpdate = task;
        taskIndex = i;
        break;
      }
    }

    if (taskToUpdate != null && taskIndex != null) {
      currentTasks[taskIndex] = updatedTask;

      await cacheTasks(currentTasks);
    } else {
      print('Erro: Tarefa não encontrada para atualização.');
    }
  }

  Future<void> addDoneTask(Task task) async {
    List<Task> currentDoneTasks = await getCachedDoneTasks();
    currentDoneTasks.add(task);

    await cacheDoneTasks(currentDoneTasks);
  }

  Future<void> deleteAllTasks() async {
    List<Task> currentTasks = await getCachedDoneTasks();

    List<Task> updatedTasks = currentTasks
        .map((task) => task.copyWith(
              isDeleted: true,
              isSynced: false,
              isModified: true,
            ))
        .toList();

    await cacheDoneTasks(updatedTasks);
  }

  Future<void> deleteOneTask(String taskId) async {
    List<Task> currentTasks = await getCachedDoneTasks();

    List<Task> updatedTasks = currentTasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(
          isDeleted: true,
          isSynced: false,
          isModified: true,
        );
      }
      return task;
    }).toList();

    await cacheDoneTasks(updatedTasks);
  }

  Future<List<Task>> searchCachedTasks(String query) async {
    return [];
  }
}