import 'dart:async';

import 'package:flutter/material.dart';
import 'package:potatoes_secured_preferences/potatoes_secured_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppSecuredPreferences securedPreferencesService;

  @override
  void initState() {
    super.initState();

    // initialize Secured preferences with SharedPreferences and
    // FlutterSecureStorage
    SharedPreferences.getInstance().then((preferences) {
      securedPreferencesService = AppSecuredPreferences(
        preferences,
        const FlutterSecureStorage()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Hello from Potatoes'),
        ),
      ),
    );
  }
}

class AppSecuredPreferences extends SecuredPreferencesService {
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  AppSecuredPreferences(super.preferences, super.secureStorage);

  // no need to encrypt, we use regular SharedPreferences
  Future<void> setUserId(String value) {
    return preferences.setString(_userIdKey, value);
  }

  String? get userId => preferences.getString(_userIdKey);

  // encrypt sensitive value
  Future<void> setAuthToken(String value) {
    return secureStorage.write(key: _authTokenKey, value: value);
  }

  @override
  FutureOr<Map<String, String>> getAuthHeaders() async {
    // get the authentication token from Secure Storage
    final token = await secureStorage.read(key: _authTokenKey);

    // return the auth map to inject into API queries
    return {
      'Authorization': 'Bearer $token'
    };
  }
}
