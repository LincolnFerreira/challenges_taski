import '../core/services/service_connectivity.dart';
import '../core/util.dart';
import '../models/task.dart';
import 'task_repository.dart';
import '../data/local/task_local_data_source.dart';
import '../data/remote/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.connectivityService,
  });

  @override
  Future<List<Task>> fetchTasks(String userId) async {
    try {
      if (await connectivityService.isConnected()) {
        final tasks = await remoteDataSource.fetchTasks(userId);
        await localDataSource.cacheTasks(tasks);
        return tasks;
      } else {
        return await localDataSource.getCachedTasks();
      }
    } catch (e) {
      return await localDataSource.getCachedTasks();
    }
  }

  Future<Task> createTask(
      String taskName, String taskDescription, String userId) async {
    String generatedTaskId = Util.generateUniqueId();

    Task newTask = Task(
        id: generatedTaskId,
        userId: userId,
        title: taskName,
        description: taskDescription,
        isModified: true,
        isSynced: false);

    await localDataSource.addTask(newTask);

    if (await connectivityService.isConnected()) {
      final postNewTask = await remoteDataSource.createTask(newTask);
      newTask =
          newTask.copyWith(id: postNewTask, isSynced: true, isModified: false);
      await localDataSource.updateTask(generatedTaskId, newTask);
    }

    return newTask;
  }

  Future<List<Task>> fetchDoneTasks(String userId) async {
    try {
      if (await connectivityService.isConnected()) {
        final List<Task> doneList =
            await remoteDataSource.fetchDoneTasks(userId);
        await localDataSource.cacheDoneTasks(doneList);
        return doneList;
      } else {
        return await localDataSource.getCachedDoneTasks();
      }
    } catch (e) {
      return await localDataSource.getCachedDoneTasks();
    }
  }

  Future<Task> updateTask(String userId, Task task) async {
    await localDataSource.updateTask(task.id, task);

    final updatedTask = await remoteDataSource.updateTask(task);
    localDataSource.updateTask(task.id, updatedTask ?? task);

    return updatedTask ?? task;
  }

  Future<void> deleteTask(String taskID) async {
    try {
      await localDataSource.deleteOneTask(taskID, false);

      if (await connectivityService.isConnected()) {
        await remoteDataSource.deleteTask(taskID);
      }
    } catch (e) {
      print('Erro ao deletar a tarefa: $e');
    }
  }

  Future<void> deleteAllTasks(String userId) async {
    try {
      await localDataSource.deleteAllTasks();

      if (await connectivityService.isConnected()) {
        await remoteDataSource.deleteAllTasks(userId);
      }
    } catch (e) {
      print('Erro ao deletar todas as tarefas: $e');
    }
  }

  Future<List<Task>> getTasksToSync() async {
    List<Task> tasks = await localDataSource.getCachedTasks();
    return tasks
        .where((task) => task.isSynced == false || task.isModified == true)
        .toList();
  }

  Future<void> syncTaskWithRemote(Task task) async {
    try {
      if (await connectivityService.isConnected()) {
        final syncedTask = await remoteDataSource.updateTask(task);

        await localDataSource.updateTask(task.id, syncedTask ?? task);
      }
    } catch (e) {
      print('Erro na sincronização da tarefa: $e');
    }
  }

  Future<List<Task>> searchTasks(String userId, String query) async {
    try {
      if (await connectivityService.isConnected()) {
        final tasks = await remoteDataSource.searchTasks(userId, query);
        return tasks;
      } else {
        return await localDataSource.searchCachedTasks(query);
      }
    } catch (e) {
      return await localDataSource.searchCachedTasks(query);
    }
  }
}
