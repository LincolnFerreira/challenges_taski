import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(String userId);
}
