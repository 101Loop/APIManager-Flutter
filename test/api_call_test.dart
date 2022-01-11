import 'dart:convert';
import 'dart:io';

import 'package:flutter_api_manager/flutter_api_manager.dart';
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

    test('check get method returns the correct response - non authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 200);
      });

      var result = await instance.request('endPoint', isAuthenticated: false);

      expect(result.isSuccessful, true);
    });

    test('check get method returns the correct response - authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 200);
      });

      var result = await instance.request('endPoint');

      expect(result.isSuccessful, true);
    });

    test('check post method returns the correct response - authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 201);
      });

      var result = await instance.request('endPoint', method: APIMethod.post);

      expect(result.isSuccessful, true);
    });

    test('check put method returns the correct response - authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 202);
      });

      var result = await instance.request('endPoint', method: APIMethod.put);

      expect(result.isSuccessful, true);
    });

    test('check patch method returns the correct response - authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {
          'data': {'id': 1, 'name': 'name'},
        };
        return http.Response(json.encode(response), 202);
      });

      var result = await instance.request('endPoint', method: APIMethod.patch);

      expect(result.isSuccessful, true);
    });

    test('check delete method returns the correct response - authenticated',
        () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 204);
      });

      var result = await instance.request('endPoint', method: APIMethod.delete);

      expect(result.isSuccessful, true);
    });

    test('check moved permanently error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 301);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'The endpoint to this API has been changed, please consider to update it.');
      }
    });

    test('check bad request error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 400);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'Please check your request and make sure you are posting a valid data body.');
      }
    });

    test('check unauthorized error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 401);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'This API needs to be authenticated with a Bearer token.');
      }
    });

    test('check forbidden error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 403);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(), 'You are not allowed to call this API.');
      }
    });

    test('check unprocessable entity error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 422);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(), 'Provided credentials are not valid.');
      }
    });

    test('check too many request error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 429);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            "You are requesting the APIs too often, please don't call the API(s) unnecessarily");
      }
    });

    test('check internal server error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 500);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'Server is not responding, please try again later!');
      }
    });

    test('check bad gateway error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 502);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'Server is not responding, please try again later!');
      }
    });

    test('check service unavailable error is being thrown', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 503);
      });

      try {
        await instance.request('endPoint', method: APIMethod.delete);
      } on APIException catch (error) {
        expect(error.toString(),
            'Server is not responding, please try again later!');
      }
    });

    test('check successful file upload', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 200);
      });

      try {
        var result =
            await instance.uploadFile('endPoint/', File('path'), 'file');
        expect(result.isSuccessful, true);
      } catch (error) {
        expect(error.runtimeType, FileSystemException);
      }
    });

    test('check file upload endpoint assertion', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 200);
      });

      expect(() async => {await instance.uploadFile('', File('path'), 'file')},
          throwsAssertionError);
      expect(
          () async => {await instance.uploadFile(null, File('path'), 'file')},
          throwsAssertionError);
    });

    test('check file upload null file assertion', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 200);
      });

      expect(() async => {await instance.uploadFile('endPoint/', null, 'file')},
          throwsAssertionError);
    });

    test('check successful file, null file key assertion', () async {
      APIManager.client = MockClient((request) async {
        final response = {};
        return http.Response(json.encode(response), 200);
      });

      expect(
          () async =>
              {await instance.uploadFile('endPoint/', File('path'), null)},
          throwsAssertionError);
    });
  });
}
