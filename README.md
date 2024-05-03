# Potatoes Secured Preferences

A Preferences service with secure storage capabilities. Built for [Potatoes](https://pub.dev/packages/potatoes).

## Getting Started

This package provides an extension of Potatoes' [PreferencesService](https://pub.dev/packages/potatoes#preferencesservice)
using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to provide
encryption capabilities.

## Usage

You simply need to extend `SecuredPreferencesService` to define you persistence logic. 
``` dart
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
```

And enjoy using it!
``` dart
// new instance
securedPreferencesService = AppSecuredPreferences(
  sharedPreferences,
  flutterSecureStorage
);

securedPreferencesService.setUserId("user id here");
securedPreferencesService.userId; // retrieve user id value
securedPreferencesService.setAuthToken("token value here");

// clean both SharedPreferences and Secure Storage
securedPreferencesService.clear();
```
