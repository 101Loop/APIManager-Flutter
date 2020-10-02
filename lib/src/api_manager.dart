import 'dart:convert';

import 'package:flutter_api_manager/src/model/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum APIMethod { get, post, put, patch, delete }

/// A singleton class for making API requests
class APIManager {
  /// Create http client, used for making API calls
  static http.Client client = http.Client();

  /// Base url of the requests
  final String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance;

  /// Private constructor
  APIManager._({this.baseUrl});

  /// Storage instance
  static FlutterSecureStorage _storage;

  /// static method to return the static singleton instance
  factory APIManager.getInstance({baseUrl}) {
    /// Initialize storage, if not already initialized
    if (_storage == null) _storage = FlutterSecureStorage();

    /// Singleton is already created, return the created one
    if (_instance != null) return _instance;

    /// create and return a new instance of [APIManager]
    assert(baseUrl != null);
    _instance = APIManager._(baseUrl: baseUrl);
    return _instance;
  }

  /// Save token, will be used throughout the app for authentication
  saveToken(String token) async {
    assert(token != '');

    /// set token
    await _storage.write(key: 'token', value: token);
  }

  /// Returns the token from the [_storage]
  Future<String> _getToken() async {
    String token;

    try {
      token = await _storage.read(key: 'token');
    } catch (_) {
      /// TODO: handle the [PlatformException] here
    }

    return token;
  }

  /// Delete the token,
  deleteToken() async {
    /// clear the storage
    _storage.deleteAll();
  }

  /// Dispose the [APIManager] instance
  static dispose() {
    _instance = null;
  }

  /// Makes the API request here
  ///
  /// [endPoint] - Endpoint of the API
  /// [method] - Type of [APIMethod]. See [APIMethod] enum for all the available methods
  /// [data] - data to be passed in the request in [Map] format
  /// [isAuthenticated] - if authenticated, Bearer token authorization will be added, otherwise not
  Future<Response> makeRequest(String endPoint, APIMethod method, {Map data, bool isAuthenticated = true}) async {
    /// Set url
    final String url = baseUrl + endPoint;

    /// Create non-auth headers
    final headers = {'Content-Type': 'application/json'};

    /// Add bearer token, if the API call is to be authenticated
    if (isAuthenticated) {
      String token = await _getToken();

      // TODO: add an assertion or check here, for null token

      headers.addAll({'Authorization': 'Bearer $token}'});
    }

    http.Response response;
    var responseBody;

    try {
      /// switch on the basis of method provided and make relevant API call
      switch (method) {
        case APIMethod.get:
          response = await client.get(url, headers: headers);
          break;
        case APIMethod.post:
          response = await client.post(url, headers: headers, body: json.encode(data));
          break;
        case APIMethod.put:
          response = await client.put(url, headers: headers, body: json.encode(data));
          break;
        case APIMethod.patch:
          response = await client.patch(url, headers: headers, body: json.encode(data));
          break;
        case APIMethod.delete:
          response = await client.delete(url, headers: headers);
          break;
      }

      /// parse the response
      responseBody = json.decode(response.body);

      /// status code of the response
      int statusCode = response.statusCode;

      /// return the Response
      return Response(data: responseBody, rawData: response, statusCode: statusCode, isSuccessful: statusCode >= 200 && statusCode < 300);
    } catch (error) {
      return Response(error: error.toString(), data: responseBody, rawData: response, isSuccessful: false);
    }
  }
}
