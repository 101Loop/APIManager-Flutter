/// A singleton class for making API requests
class APIManager {
  /// Base url of the requests
  final String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance;

  /// Private constructor
  APIManager._({this.baseUrl});

  /// static method to return the static singleton instance
  factory APIManager.getInstance({baseUrl}) {
    /// Singleton is already created, return the created one
    if (_instance != null) return _instance;

    /// create and return a new instance of [APIManager]
    assert(baseUrl != null);
    _instance = APIManager._(baseUrl: baseUrl);
    return _instance;
  }

  /// Dispose the [APIManager] instance
  static dispose() {
    _instance = null;
  }
}
