import 'package:challenges_taski/data/remote/task_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:challenges_taski/models/task.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TaskRemoteDataSource taskRemoteDataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    taskRemoteDataSource = TaskRemoteDataSource(firestore: fakeFirestore);
  });

  test('fetchTasks returns list of tasks', () async {
    // Arrange
    final taskData = {
      'title': 'Test Task',
      'userId': 'user1',
      'isCompleted': false,
      'description': 'description task',
    };

    // Add fake data to Firestore
    await fakeFirestore.collection('tasks').add(taskData);

    // Act
    final tasks = await taskRemoteDataSource.fetchTasks('user1');

    // Assert
    expect(tasks, isA<List<Task>>());
    expect(tasks.length, 1);
    expect(tasks[0].title, 'Test Task');
  });

  test('createTask creates a new task', () async {
    // Arrange
    final newTask = Task(
        title: 'New Task',
        userId: 'user1',
        isCompleted: false,
        description: 'new task description');

    // Act
    final taskId = await taskRemoteDataSource.createTask(newTask);

    // Assert
    final doc = await fakeFirestore.collection('tasks').doc(taskId).get();
    expect(doc.exists, true);
    expect(doc.data()!['title'], 'New Task');
  });

  test('updateTask updates a task', () async {
    // Arrange
    final taskData = {
      'title': 'Old Task',
      'userId': 'user1',
      'isCompleted': false,
      'description': 'old task description',
    };
    final docRef = await fakeFirestore.collection('tasks').add(taskData);
    final taskToUpdate = Task(
      id: docRef.id,
      title: 'Updated Task',
      userId: 'user1',
      isCompleted: true,
      description: 'updated task description',
    );

    // Act
    final updatedTask = await taskRemoteDataSource.updateTask(taskToUpdate);

    // Assert
    final doc =
        await fakeFirestore.collection('tasks').doc(updatedTask?.id).get();
    expect(doc.data()!['title'], 'Updated Task');
    expect(doc.data()!['isCompleted'], true);
  });
}
