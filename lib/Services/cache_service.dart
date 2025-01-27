import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('cache');
  }

  void saveData(String key, dynamic data) {
    final box = Hive.box('cache');
    box.put(key, data);
  }

  dynamic getData(String key) {
    final box = Hive.box('cache');
    return box.get(key);
  }

  void removeData(String key) {
    final box = Hive.box('cache');
    box.delete(key);
  }
}
