/// A singleton class for making API requests
class APIManager {
  /// Base url of the requests
  static String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance = APIManager._getInstance();

  /// Constructor for [APIManager]
  factory APIManager(String baseUrl) {
    APIManager.baseUrl = baseUrl;
    return _instance;
  }

  /// A private method that returns the
  APIManager._getInstance();
}
