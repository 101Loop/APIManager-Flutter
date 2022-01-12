/// Custom exception class
class APIException implements Exception {
  /// response data
  final data;

  /// Error in string format
  final String? error;

  /// Status code of the API call
  final int statusCode;

  APIException(this.error, {this.data = '', this.statusCode = -1});

  @override
  String toString() => error!;
}
