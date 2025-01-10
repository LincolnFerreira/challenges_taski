import 'package:challenges_taski/models/user.dart';

import '../data/local/user_local_data_source.dart';
import '../data/remote/user_remote_data_source.dart';

class UserRepositoryImpl {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<User> createUser({required String name, required String email}) async {
    return await remoteDataSource.createUser(name, email);
  }

  Future<User?> getUserName() async => await localDataSource.getCachedUser();
}
