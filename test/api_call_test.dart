import 'dart:convert';

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

  group('test singleton instance', () {
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
  });
}
