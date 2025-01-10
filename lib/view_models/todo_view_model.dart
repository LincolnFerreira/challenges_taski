import 'package:challenges_taski/core/services/service_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:challenges_taski/repositories/task_repository_impl.dart';
import 'package:challenges_taski/models/task.dart';

class TodoViewModel extends ChangeNotifier {
  final TaskRepositoryImpl taskRepository;
  final ConnectivityService connectivityService;
  List<Task>? todoList;
  List<Task>? doneList;

  TodoViewModel(
      {required this.connectivityService, required this.taskRepository});

  Future<void> fetchTodoList(String userId) async {
    todoList = await taskRepository.fetchTasks(userId);
    notifyListeners();
  }

  Future<void> createTask(
      String taskName, String taskDescription, String userId) async {
    final Task createdTask =
        await taskRepository.createTask(taskName, taskDescription, userId);

    todoList?.add(createdTask);
    notifyListeners();
  }

  Future<void> fetchDoneList(String userId) async {
    doneList = await taskRepository.fetchDoneTasks(userId);
    notifyListeners();
  }

  Future<void> updateTask(String userId, Task task) async {
    final Task updatedTask = await taskRepository.updateTask(userId, task);
    notifyListeners();
  }

  Future<void> deleteTask(String userId, String localId) async {
    await taskRepository.deleteTask(localId);

    await fetchTodoList(userId);
    await fetchDoneList(userId);
  }

  Future<void> deleteAllTasks(String userId) async {
    await taskRepository.deleteAllTasks(userId);

    await fetchTodoList(userId);
    await fetchDoneList(userId);
  }

  Future<List<Task>> searchTasks(String userId, String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await taskRepository.searchTasks(userId, query);
  }
}
