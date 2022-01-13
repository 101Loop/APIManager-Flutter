/// Response class
/// Will be used for returning the response from API call
class Response {
  final data;
  final int statusCode;
  final String? error;
  final rawData;
  final bool? isSuccessful;

  Response({
    this.data,
    this.statusCode =
        -1, // -1 will be returned if the response couldn't be processed somehow
    this.error,
    this.rawData,
    this.isSuccessful,
  });
}
