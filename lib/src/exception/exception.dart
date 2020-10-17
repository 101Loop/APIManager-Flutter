/// Custom exception class
class APIException implements Exception {
  /// Error in string format
  String error;

  /// Status code of the API call
  int statusCode;

  APIException(this.error, {this.statusCode = -1});
}
