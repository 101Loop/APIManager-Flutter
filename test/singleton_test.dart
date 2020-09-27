import 'package:flutter_api_manager/src/api_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('check only single instance is created', () {
    /// Create an instance of [APIManager]
    APIManager instance = APIManager.getInstance(baseUrl: 'google');

    /// Create another instance of [APIManager]
    APIManager instance1 = APIManager.getInstance();

    /// Check if the same instance is returned or not
    expect(instance.baseUrl, 'google');
    expect(instance1.baseUrl, 'google');
  });

  test('check null base url assertion', () {
    /// Check if the null assertion is being thrown or not
    expect(() {
      APIManager.getInstance();
    }, throwsAssertionError);
  });
}
