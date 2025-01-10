import 'package:challenges_taski/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource({required this.sharedPreferences});

  Future<void> cacheUser(User user) async {
    await sharedPreferences.setString('email', user.email);
    await sharedPreferences.setString('name', user.name);
    await sharedPreferences.setString('uuid', user.uuid ?? '');
  }

  Future<User?> getCachedUser() async {
    final email = sharedPreferences.getString('email');
    final name = sharedPreferences.getString('name');
    final uuid = sharedPreferences.getString('uuid');

    if (email != null && name != null && uuid != null) {
      return User(email: email, name: name, uuid: uuid);
    }
    return null;
  }
}
