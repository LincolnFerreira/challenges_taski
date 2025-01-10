import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:challenges_taski/repositories/task_repository_impl.dart';
import 'package:challenges_taski/models/task.dart';

import '../mocks/mocks.dart';

void main() {
  late TaskRepositoryImpl taskRepository;
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockLocalDataSource = MockTaskLocalDataSource();
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockConnectivityService = MockConnectivityService();
    taskRepository = TaskRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      connectivityService: mockConnectivityService,
    );

    registerFallbackValue(Task(
      id: '1',
      userId: 'user1',
      title: 'Test Task',
      description: '',
      isCompleted: false,
    ));
  });

  group('fetchTasks', () {
    test('should fetch tasks from remote and cache them when online', () async {
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => true);
      final taskList = [
        Task(
            id: '1',
            userId: 'user1',
            title: 'Test Task',
            description: '',
            isCompleted: false)
      ];
      when(() => mockRemoteDataSource.fetchTasks('user1'))
          .thenAnswer((_) async => taskList);
      when(() => mockLocalDataSource.cacheTasks(taskList))
          .thenAnswer((_) async => Future.value());

      final result = await taskRepository.fetchTasks('user1');

      expect(result, taskList);
      verify(() => mockRemoteDataSource.fetchTasks('user1')).called(1);
      verify(() => mockLocalDataSource.cacheTasks(taskList)).called(1);
    });

    test('should fetch tasks from local when offline', () async {
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);
      final taskList = [
        Task(
            id: '1',
            userId: 'user1',
            title: 'Test Task',
            description: '',
            isCompleted: false)
      ];
      when(() => mockLocalDataSource.getCachedTasks())
          .thenAnswer((_) async => taskList);

      final result = await taskRepository.fetchTasks('user1');

      expect(result, taskList);
      verify(() => mockLocalDataSource.getCachedTasks()).called(1);
    });
  });

  group('createTask', () {
    test('should create task and sync with remote when online', () async {
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.createTask(any()))
          .thenAnswer((_) async => 'remoteId');

      when(() => mockLocalDataSource.addTask(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.updateTask(any(), any()))
          .thenAnswer((_) async => Future.value());

      late Task capturedTaskForAdd;
      late Task capturedTaskForUpdate;

      when(() => mockLocalDataSource.addTask(captureAny()))
          .thenAnswer((invocation) async {
        capturedTaskForAdd = invocation.positionalArguments.first as Task;
        return Future.value();
      });

      when(() => mockLocalDataSource.updateTask(any(), captureAny()))
          .thenAnswer((invocation) async {
        capturedTaskForUpdate = invocation.positionalArguments[1] as Task;
        return Future.value();
      });

      final result =
          await taskRepository.createTask('New Task', 'Description', 'user1');

      expect(result.id, 'remoteId');
      expect(result.isSynced, true);
      expect(result.isModified, false);

      verify(() => mockLocalDataSource.addTask(capturedTaskForAdd)).called(1);

      verify(() => mockRemoteDataSource.createTask(capturedTaskForAdd))
          .called(1);

      verify(() => mockLocalDataSource.updateTask(
          capturedTaskForAdd.idLocal, capturedTaskForUpdate)).called(1);

      expect(capturedTaskForAdd.isSynced, false);
      expect(capturedTaskForUpdate.isSynced, true);
      expect(capturedTaskForUpdate.id, 'remoteId');
    });

    test('should create task and not sync if offline', () async {
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);

      when(() => mockLocalDataSource.addTask(any()))
          .thenAnswer((_) async => Future.value());

      final result =
          await taskRepository.createTask('New Task', 'Description', 'user1');

      expect(result.idLocal, isNotEmpty);
      expect(result.isSynced, false);
      expect(result.isModified, true);

      verify(() => mockLocalDataSource.addTask(any())).called(1);

      verifyNever(() => mockRemoteDataSource.createTask(any()));
    });
  });
}
