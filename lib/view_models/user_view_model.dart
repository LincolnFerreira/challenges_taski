import 'package:challenges_taski/models/user.dart';
import 'package:challenges_taski/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepositoryImpl repository;

  User? _user;
  User? get user => _user;

  UserViewModel({required this.repository});

  Future<void> createUser(String email, String name) async {
    final createdUser = await repository.createUser(email: email, name: name);

    await repository.localDataSource.cacheUser(createdUser);
    notifyListeners();
  }

  Future<void> getCachedUser() async {
    _user = await repository.localDataSource.getCachedUser();
    notifyListeners();
  }
}
