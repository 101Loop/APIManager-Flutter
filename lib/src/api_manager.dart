import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class for making API requests
class APIManager {
  /// Base url of the requests
  final String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance;

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
  saveToken(String token) async {
    /// initialize prefs, if not already done
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    /// set token
    prefs.setString('token', token);
  }

  /// Delete the token,
  deleteToken() async {
    /// initialize prefs, if not already done
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    /// clear the prefs
    prefs.clear();
  }

  /// Dispose the [APIManager] instance
  static dispose() {
    _instance = null;
  }
}
