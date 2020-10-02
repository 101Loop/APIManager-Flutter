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
}
