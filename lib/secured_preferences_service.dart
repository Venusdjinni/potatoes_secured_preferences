import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:potatoes/potatoes.dart';

abstract class SecuredPreferencesService extends PreferencesService {
  @protected
  final FlutterSecureStorage secureStorage;

  const SecuredPreferencesService(super.preferences, this.secureStorage);

  @override
  Future<void> clear() async {
    await secureStorage.deleteAll();
    return super.clear();
  }
}