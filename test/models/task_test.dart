import 'package:challenges_taski/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task', () {
    test('should initialize correctly with default values', () {
      final task = Task(
        title: 'Test Task',
        description: 'This is a test task',
      );

      expect(task.id, isNull);
      expect(task.id, isNull);
      expect(task.title, 'Test Task');
      expect(task.description, 'This is a test task');
      expect(task.isCompleted, false);
      expect(task.userId, isNull);
      expect(task.isModified, false);
      expect(task.isSynced, false);
      expect(task.isDeleted, false);
    });

    test('should convert to map correctly', () {
      final task = Task(
        title: 'Test Task',
        description: 'This is a test task',
        isCompleted: true,
        userId: 'user123',
      );

      final map = task.toMap();
      expect(map, {
        'userId': 'user123',
        'title': 'Test Task',
        'description': 'This is a test task',
        'isCompleted': true,
      });
    });

    test('should convert to full map correctly', () {
      final task = Task(
        id: 'remote123',
        title: 'Test Task',
        description: 'This is a test task',
        isCompleted: true,
        userId: 'user123',
        isModified: true,
        isSynced: false,
        isDeleted: true,
      );

      final map = task.toFullMap();
      expect(map, {
        'id': 'remote123',
        'title': 'Test Task',
        'description': 'This is a test task',
        'isCompleted': true,
        'userId': 'user123',
        'isModified': true,
        'isSynced': false,
        'isDeleted': true,
      });
    });

    test('should create Task from map correctly', () {
      final map = {
        'id': 'remote123',
        'title': 'Test Task',
        'description': 'This is a test task',
        'isCompleted': true,
        'userId': 'user123',
        'isModified': true,
        'isSynced': false,
        'isDeleted': true,
      };

      final task = Task.fromMap(map);

      expect(task.id, 'local123');
      expect(task.id, 'remote123');
      expect(task.title, 'Test Task');
      expect(task.description, 'This is a test task');
      expect(task.isCompleted, true);
      expect(task.userId, 'user123');
      expect(task.isModified, true);
      expect(task.isSynced, false);
      expect(task.isDeleted, true);
    });

    test('should copy Task with updated fields correctly', () {
      final task = Task(
        id: 'remote123',
        title: 'Test Task',
        description: 'This is a test task',
        isCompleted: false,
        userId: 'user123',
        isModified: false,
        isSynced: false,
        isDeleted: false,
      );

      final updatedTask = task.copyWith(
        title: 'Updated Task',
        isCompleted: true,
        isDeleted: true,
      );

      expect(updatedTask.id, 'local123');
      expect(updatedTask.id, 'remote123');
      expect(updatedTask.title, 'Updated Task');
      expect(updatedTask.description, 'This is a test task');
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.userId, 'user123');
      expect(updatedTask.isModified, false);
      expect(updatedTask.isSynced, false);
      expect(updatedTask.isDeleted, true);
    });
  });
}
