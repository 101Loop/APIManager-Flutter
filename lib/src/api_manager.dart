import 'dart:convert';
import 'dart:io';

import 'package:flutter_api_manager/src/exception/exception.dart';
import 'package:flutter_api_manager/src/model/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

enum APIMethod { get, post, put, patch, delete }

/// A singleton class for making API requests
class APIManager {
  /// Create http client, used for making API calls
  static http.Client client = http.Client();

  /// Base url of the requests
  final String baseUrl;

  /// Instance of [APIManager]
  static APIManager _instance;

  String _token;

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
  login(String token) async {
    assert(token != null && token.isNotEmpty);

    /// set token
    _token = token;
    try {
      await _storage.write(key: 'token', value: token);
    } catch (_) {
      /// TODO: handle the [PlatformException] here
    }
  }

  /// Returns the token from the [_storage]
  Future<String> _getToken() async {
    try {
      _token = await _storage.read(key: 'token');
    } catch (_) {
      /// TODO: handle the [PlatformException] here
    }

    return _token;
  }

  /// Check if the user is logged in or not
  Future<bool> isLoggedIn() async {
    return await _getToken() != null;
  }

  /// Delete the token,
  logout() async {
    /// clear the storage
    try {
      await _storage.deleteAll();
    } catch (_) {
      /// TODO: handle the [PlatformException] here
    }
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

    /// Create non-auth header
    final headers = {'Content-Type': 'application/json'};

    /// Add bearer token, if the API call is to be authenticated
    if (isAuthenticated) {
      String token = await _getToken();

      // TODO: add an assertion or check here, for null token

      headers.addAll({'Authorization': 'Bearer $token}'});
    }

    http.Response response;

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

    return _handleResponse(response);
  }

  /// This method uploads the file
  ///
  /// [endPoint] - Endpoint of the API
  /// [file] - the file which is to be uploaded
  /// [fileKey] - file will be posted under this key
  /// [data] - Map representation of data to be posted along with the file
  /// [isAuthenticated] - if the API is to be authenticated or not
  Future<Response> uploadFile(String endPoint, File file, String fileKey, {Map<String, String> data, bool isAuthenticated = true}) async {
    assert(endPoint != null && endPoint.isNotEmpty);
    assert(file != null);
    assert(fileKey != null && fileKey.isNotEmpty);

    /// Common header
    var headers = {'Content-Type': 'application/json'};

    /// if the API is to be authenticated, add a bearer token
    if (isAuthenticated) {
      headers.addAll({'Authorization': 'Bearer ${await _getToken()}'});
    }

    /// Create multipart request
    final mimeTypeData = lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
    final multipartRequest = http.MultipartRequest('POST', Uri.parse(baseUrl + endPoint));
    final _file = await http.MultipartFile.fromPath(fileKey, file.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    /// Add headers, files and fields to the multipart request
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(_file);
    if (data != null) multipartRequest.fields.addAll(data);

    var response;

    /// Send the request and await for the response
    final streamedResponse = await multipartRequest.send();
    response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  /// This method handles the response of the API
  _handleResponse(http.Response response) {
    /// parse the response
    var responseBody = json.decode(response.body);

    /// status code of the response
    int statusCode = response.statusCode;

    bool isSuccessful = statusCode >= 200 && statusCode < 300;

    String error;
    if (!isSuccessful) {
      switch (statusCode) {
        case HttpStatus.movedPermanently:
        case HttpStatus.movedTemporarily:
          error = "The endpoint to this API has been changed, please consider to update it.";
          break;

        case HttpStatus.badRequest:
          error = "Please check your request and make sure you are posting a valid data body.";
          break;

        case HttpStatus.unauthorized:
          error = "This API needs to be authenticated with a Bearer token.";
          break;

        case HttpStatus.forbidden:
          error = "You are not allowed to call this API.";
          break;

        case HttpStatus.unprocessableEntity:
          error = "Provided credentials are not valid.";
          break;

        case HttpStatus.tooManyRequests:
          error = "You are requesting the APIs multiple times, please don't call the API(s) unnecessarily";
          break;

        case HttpStatus.internalServerError:
        case HttpStatus.badGateway:
        case HttpStatus.serviceUnavailable:
          error = "Server is not responding, please try again later!";
          break;

        default:
          error = "Something went wrong, please try again later!";
      }

      throw APIException(error, data: responseBody, statusCode: statusCode);
    }

    /// return the Response
    return Response(data: responseBody, rawData: response, statusCode: statusCode, isSuccessful: isSuccessful, error: error);
  }
}
