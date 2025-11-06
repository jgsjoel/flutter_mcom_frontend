import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securestoreservice {

  static FlutterSecureStorage? _securestoreInstance;

  static FlutterSecureStorage _getStorageInstance(){
      _securestoreInstance ??= const FlutterSecureStorage();
      return _securestoreInstance!;
  }

  static Future<void> setItem(String key,String value) async{
    final store = _getStorageInstance();
    await store.write(key: key, value: value);
  }

  static Future<String?> getItem(String key) async{
    final store = _getStorageInstance();
    return await store.read(key: key);
  }

  static Future<void> deleteItem(String key) async{
    final store = _getStorageInstance();
    await store.delete(key: key);
  }

}