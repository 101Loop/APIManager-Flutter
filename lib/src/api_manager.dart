import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class for making API requests
class APIManager {
  /// Base url of the requests
  final String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance;

  String _key;

  /// Private constructor
  APIManager._({this.baseUrl});

  /// Shared prefs instance
  static SharedPreferences prefs;

  /// static method to return the static singleton instance
  factory APIManager.getInstance({baseUrl}) {
    /// Singleton is already created, return the created one
    if (_instance != null) return _instance;

    /// create and return a new instance of [APIManager]
    assert(baseUrl != null);
    _instance = APIManager._(baseUrl: baseUrl);
    return _instance;
  }

  /// Save token, will be used throughout the app for authentication
  saveToken({String key = 'token', String token}) async {
    assert(token != null);
    
    _key = key;

    /// initialize prefs, if not already done
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    /// set token
    await prefs.setString(_key, token);
  }

  /// Delete the token,
  deleteToken() async {
    assert(_key != null);
    
    /// initialize prefs, if not already done
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    /// clear the prefs
    prefs.remove(_key);
  }

  /// Dispose the [APIManager] instance
  static dispose() {
    _instance = null;
  }
}
