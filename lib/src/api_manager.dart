import 'dart:convert';
import 'dart:io';

import 'package:flutter_api_manager/src/model/response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum APIMethod { get, post, put, patch, delete }

/// A singleton class for making API requests
class APIManager {
  /// Create http client, used for making API calls
  http.Client client = http.Client();

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

    await _initializeToken();

    /// set token
    await prefs.setString(_key, token);
  }

  /// gets token from the shared prefs
  _getToken() async {
    await _initializeToken();

    /// get token
    prefs.getString(_key);
  }

  /// Delete the token,
  deleteToken() async {
    assert(_key != null);

    await _initializeToken();

    /// clear the prefs
    prefs.remove(_key);
  }

  /// Dispose the [APIManager] instance
  static dispose() {
    _instance = null;
  }

  /// Initialize [SharedPreferences] instance
  _initializeToken() async {
    /// initialize prefs, if not already done
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  /// Makes the API request here
  Future<Response> makeRequest(String endPoint, APIMethod method, {Map data, bool isAuthenticated = true}) async {
    /// Set url
    final String url = baseUrl + endPoint;

    /// Create non-auth headers
    final Map headers = {'Content-Type': 'application/json'};

    /// Add bearer token, if the API call is to be authenticated
    if (isAuthenticated) headers.addAll({'Authorization': 'Bearer ${await _getToken()}'});

    http.Response response;
    String responseBody;

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

      /// return the Response
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.accepted || response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.noContent) {
        return Response(data: responseBody, rawData: response, statusCode: response.statusCode, isSuccessful: true);
      }
    } catch (error) {
      return Response(error: error.toString(), statusCode: response.statusCode, data: responseBody, rawData: response, isSuccessful: false);
    }

    return Response(error: 'Something went wrong', isSuccessful: false);
  }
}
