import 'package:flutter_api_manager/src/api_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Makes sure that all the previous instances are disposed off.
  setUp(() {
    APIManager.dispose();
  });

  tearDownAll(() {
    APIManager.dispose();
  });

  group('test singleton instance', () {
    test('check only single instance is created', () {
      /// Create an instance of [APIManager]
      APIManager instance = APIManager.getInstance(baseUrl: 'base_url');

      /// Create another instance of [APIManager]
      APIManager instance1 = APIManager.getInstance();

      /// Check if the same instance is returned or not
      expect(instance.baseUrl, 'base_url');
      expect(instance1.baseUrl, 'base_url');
    });

    test('check null base url assertion', () {
      /// Disposing the [APIManager] instance
      APIManager.dispose();

      /// Check if the null assertion is being thrown or not
      expect(() => {APIManager.getInstance()}, throwsAssertionError);
    });

    test('check the base url after disposing the singleton instance', () {
      /// Disposing the [APIManager] instance
      APIManager.dispose();

      /// Check if the base url matches on creating the instance, after disposal
      expect(APIManager.getInstance(baseUrl: 'base url').baseUrl, 'base url');
    });
  });

  group('test token is being saved and deleted properly or not', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('check token is being saved', () async {
      /// Create an instance of [APIManager]
      APIManager instance = APIManager.getInstance(baseUrl: 'base_url');

      await instance.saveToken('token123');

      var result = await instance.isLoggedIn();

      /// Check if the user is logged in
      expect(result, true);
    });

    test('check the user is logged out', () async {
      /// Create an instance of [APIManager]
      APIManager instance = APIManager.getInstance(baseUrl: 'base_url');

      /// Simulating that the token is null
      await instance.deleteToken();

      var result = await instance.isLoggedIn();

      /// Check if the user is logged out
      expect(result, false);
    });

    test('check null token raises assertion error', () async {
      /// Create an instance of [APIManager]
      APIManager instance = APIManager.getInstance(baseUrl: 'base_url');

      /// Check if the user is logged out
      expect(() async => {await instance.saveToken(null)}, throwsAssertionError);
    });

    test('check empty token raises assertion error', () async {
      /// Create an instance of [APIManager]
      APIManager instance = APIManager.getInstance(baseUrl: 'base_url');

      /// Check if the user is logged out
      expect(() async => {await instance.saveToken('')}, throwsAssertionError);
    });
  });
}
