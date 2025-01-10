import 'dart:async';

import '../../models/task.dart';
import '../../repositories/task_repository_impl.dart';

class SyncService {
  final TaskRepositoryImpl taskRepository;

  SyncService({required this.taskRepository});

  void startSyncing() {
    Timer.periodic(Duration(minutes: 3), (timer) async {
      await syncTasks();
    });
  }

  Future<void> syncTasks() async {
    try {
      final List<Task> tasksToSync = await taskRepository.getTasksToSync();

      if (tasksToSync.isNotEmpty) {
        for (var task in tasksToSync) {
          await taskRepository.syncTaskWithRemote(task);
        }
      } else {
        print('Nenhuma tarefa para sincronizar.');
      }
    } catch (e) {
      print('Erro ao tentar sincronizar tarefas: $e');
    }
  }
}
