import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSource({required this.firestore});

  Future<List<Task>> fetchTasks(String userId) async {
    final querySnapshot = await firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: false)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Task.fromMap(data);
    }).toList();
  }

  Future<String> createTask(Task newTask) async {
    try {
      var docRef = await firestore.collection('tasks').add(newTask.toMap());
      String taskId = docRef.id;

      return taskId;
    } catch (e) {
      throw Exception('Erro ao criar a tarefa: $e');
    }
  }

  Future<Task?> updateTask(Task taskToUpdate) async {
    await firestore
        .collection('tasks')
        .doc(taskToUpdate.id)
        .update(taskToUpdate.toMap());

    return taskToUpdate;
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir a tarefa: $e');
    }
  }

  Future<List<Task>> fetchDoneTasks(String userId) async {
    final querySnapshot = await firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Task.fromMap(data);
    }).toList();
  }

  Future<void> deleteAllTasks(String userId) async {
    try {
      final batch = firestore.batch();
      final querySnapshot = await firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao excluir todas as tarefas: $e');
    }
  }

  Future<void> deleteOneTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir a tarefa: $e');
    }
  }

//TODO: arrumar
  Future<List<Task>> searchTasks(String userId, String query) async {
    try {
      final querySnapshot = await firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false) // Ignora tarefas deletadas
          .get();

      // Filtra os documentos localmente para encontrar o texto da busca
      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data();
        final title = data['title']?.toString().toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      });

      // Converte os documentos filtrados em uma lista de tarefas
      return filteredDocs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }
}
