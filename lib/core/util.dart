import 'dart:math';

class Util {
  static String generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomString = Random().nextInt(10000).toString().padLeft(4, '0');
    return '$timestamp-$randomString';
  }
}
