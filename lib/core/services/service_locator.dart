import 'service_connectivity.dart';
import 'service_sync.dart';
import '../../data/local/user_local_data_source.dart';
import '../../data/remote/user_remote_data_source.dart';
import '../../repositories/user_repository_impl.dart';
import '../../view_models/todo_view_model.dart';
import '../../view_models/user_view_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../repositories/task_repository_impl.dart';
import '../../data/local/task_local_data_source.dart';
import '../../data/remote/task_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final UserViewModel userViewModel;
  late final TodoViewModel todoViewModel;

  void initialize({required FirebaseFirestore firestore}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final connectivityService = ConnectivityService();
    final localDataSource =
        UserLocalDataSource(sharedPreferences: sharedPreferences);
    final remoteDataSource = UserRemoteDataSource(firestore: firestore);
    final taskLocalDataSource =
        TaskLocalDataSource(sharedPreferences: sharedPreferences);
    final taskRemoteDataSource = TaskRemoteDataSource(firestore: firestore);

    final userRepository = UserRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final taskRepository = TaskRepositoryImpl(
      localDataSource: taskLocalDataSource,
      remoteDataSource: taskRemoteDataSource,
      connectivityService: connectivityService,
    );

    userViewModel = UserViewModel(repository: userRepository);
    todoViewModel = TodoViewModel(
      taskRepository: taskRepository,
      connectivityService: connectivityService,
    );
    final syncService = SyncService(taskRepository: taskRepository);

    syncService.startSyncing();
  }
}
