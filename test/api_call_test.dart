import 'dart:convert';

import 'package:flutter_api_manager/flutter_api_manager.dart';
import 'package:flutter_api_manager/src/exception/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  /// Makes sure that all the previous instances are disposed off.
  setUp(() {
    APIManager.dispose();
  });

  tearDownAll(() {
    APIManager.dispose();
  });

  group('test makeRequest method', () {
    /// Ensures that everything is bounded correctly
    TestWidgetsFlutterBinding.ensureInitialized();

    /// Create an instance of [APIManager]
    APIManager instance = APIManager.getInstance(baseUrl: 'base_url/');

    test('check get method returns the correct response - non authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 200);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.get, isAuthenticated: false);

      expect(result.isSuccessful, true);
    });

    test('check get method returns the correct response - authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 200);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.get);

      expect(result.isSuccessful, true);
    });

    test('check post method returns the correct response - authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 201);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.post);

      expect(result.isSuccessful, true);
    });

    test('check put method returns the correct response - authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 202);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.put);

      expect(result.isSuccessful, true);
    });

    test('check patch method returns the correct response - authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 202);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.patch);

      expect(result.isSuccessful, true);
    });

    test('check delete method returns the correct response - authenticated', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 204);
      });

      var result = await instance.makeRequest('endPoint', APIMethod.delete);

      expect(result.isSuccessful, true);
    });

    test('check moved permanently error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 301);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'The endpoint to this API has been changed, please consider to update it.');
      }
    });

    test('check bad request error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 401);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Please check your request and make sure you are posting a valid data body');
      }
    });

    test('check unauthorized error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 401);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'This API needs to be authenticated with a Bearer token.');
      }
    });

    test('check forbidden error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 403);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'You are not allowed to call this API.');
      }
    });

    test('check unprocessable entity error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 422);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Provided credentials are not valid.');
      }
    });

    test('check too many request error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 429);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Provided credentials are not valid.');
      }
    });

    test('check internal server error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 500);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Server is not responding, Please try again later!');
      }
    });

    test('check bad gateway error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 502);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Server is not responding, Please try again later!');
      }
    });

    test('check service unavailable error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 503);
      });

      try {
        await instance.makeRequest('endPoint', APIMethod.delete);
      } on APIException catch (error){
        expect(error.error, 'Server is not responding, Please try again later!');
      }
    });
  });
}
