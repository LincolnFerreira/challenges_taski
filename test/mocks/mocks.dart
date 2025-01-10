import 'package:challenges_taski/core/services/service_connectivity.dart';
import 'package:challenges_taski/data/local/task_local_data_source.dart';
import 'package:challenges_taski/data/remote/task_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}
