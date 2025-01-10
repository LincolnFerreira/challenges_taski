import 'package:challenges_taski/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource({required this.firestore});

  Future<User?> createUser(User user) async {
    final userData = {
      'uuid': user.uuid,
      'name': user.name,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await firestore.collection('users').doc(user.uuid).set(userData);

    return user;
  }
}
