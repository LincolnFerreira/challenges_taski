import 'dart:convert';

import 'package:challenges_taski/data/local/task_local_data_source.dart';
import 'package:challenges_taski/models/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TaskLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TaskLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  group('TaskLocalDataSource', () {
    const tasksKey = 'tasks';
    const doneTasksKey = 'done_tasks';

    final task = Task(
      idLocal: '123',
      title: 'Test Task',
      description: 'Description',
      isCompleted: false,
      userId: 'user1',
      isModified: false,
      isSynced: true,
    );

    final taskJson = jsonEncode(task.toFullMap());
    final taskList = [task];
    final taskJsonList = [taskJson];

    test('should cache tasks successfully', () async {
      when(() => mockSharedPreferences.setStringList(tasksKey, taskJsonList))
          .thenAnswer((_) async => true);

      await dataSource.cacheTasks(taskList);

      verify(() => mockSharedPreferences.setStringList(tasksKey, taskJsonList))
          .called(1);
    });

    test('should retrieve cached tasks', () async {
      when(() => mockSharedPreferences.getStringList(tasksKey))
          .thenReturn(taskJsonList);

      final result = await dataSource.getCachedTasks();

      for (var i = 0; i < result.length; i++) {
        expect(result[i].id, taskList[i].id);
        expect(result[i].title, taskList[i].title);
      }

      verify(() => mockSharedPreferences.getStringList(tasksKey)).called(1);
    });

    test('should return empty list if no cached tasks', () async {
      when(() => mockSharedPreferences.getStringList(tasksKey))
          .thenReturn(null);

      final result = await dataSource.getCachedTasks();

      expect(result, []);
      verify(() => mockSharedPreferences.getStringList(tasksKey)).called(1);
    });

    test('should add a task and cache it', () async {
      when(() => mockSharedPreferences.getStringList(tasksKey))
          .thenReturn(taskJsonList);
      when(() => mockSharedPreferences.setStringList(tasksKey, any()))
          .thenAnswer((_) async => true);

      await dataSource.addTask(task);

      verify(() => mockSharedPreferences.setStringList(tasksKey, any()))
          .called(1);
    });

    test('should update a task if it exists', () async {
      final updatedTask = task.copyWith(title: 'Updated Task');
      final updatedTaskJsonList = [jsonEncode(updatedTask.toFullMap())];

      when(() => mockSharedPreferences.getStringList(tasksKey))
          .thenReturn(taskJsonList);
      when(() => mockSharedPreferences.setStringList(
          tasksKey, updatedTaskJsonList)).thenAnswer((_) async => true);

      await dataSource.updateTask(task.idLocal, updatedTask);

      verify(() => mockSharedPreferences.setStringList(
          tasksKey, updatedTaskJsonList)).called(1);
    });

    test('should not update a task if it does not exist', () async {
      when(() => mockSharedPreferences.getStringList(tasksKey)).thenReturn([]);

      await dataSource.updateTask('non_existent_id', task);

      verifyNever(() => mockSharedPreferences.setStringList(any(), any()));
    });

    test('should delete all tasks by marking them as deleted', () async {
      final deletedTaskList = [
        task.copyWith(isDeleted: true, isModified: true, isSynced: false)
      ];
      final deletedTaskJsonList = deletedTaskList
          .map((deletedTask) => jsonEncode(deletedTask.toFullMap()))
          .toList();

      when(() => mockSharedPreferences.getStringList(doneTasksKey))
          .thenReturn(taskJsonList);
      when(() => mockSharedPreferences.setStringList(
          doneTasksKey, deletedTaskJsonList)).thenAnswer((_) async => true);

      await dataSource.deleteAllTasks();

      verify(() => mockSharedPreferences.setStringList(
          doneTasksKey, deletedTaskJsonList)).called(1);
    });

    test('should delete one task by marking it as deleted', () async {
      final deletedTask = task.copyWith(
        isDeleted: true,
        isModified: true,
        isSynced: false,
      );
      final deletedTaskJsonList = [jsonEncode(deletedTask.toFullMap())];

      when(() => mockSharedPreferences.getStringList(doneTasksKey))
          .thenReturn(taskJsonList);
      when(() => mockSharedPreferences.setStringList(
          doneTasksKey, deletedTaskJsonList)).thenAnswer((_) async => true);

      await dataSource.deleteOneTask(task.id!);

      verify(() => mockSharedPreferences.setStringList(
          doneTasksKey, deletedTaskJsonList)).called(1);
    });
  });
}
