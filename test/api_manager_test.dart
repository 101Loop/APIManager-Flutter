import 'package:flutter_api_manager/src/api_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  group('test token feature', () {
    /// Ensure that test widgets binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();

    /// Create singleton instance for [APIManager]
    APIManager apiManager = APIManager.getInstance(baseUrl: 'base_url');

    test('check token is being saved', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token
      await apiManager.saveToken(token: 'my_token');

      expect(APIManager.prefs.getString('token'), 'my_token');
    });

    test('check null is being returned for invalid key', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token
      await apiManager.saveToken(token: 'my_token');

      expect(APIManager.prefs.getString('random_key'), null);
    });

    test('check token is being returned for the named key', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token with a named key
      await apiManager.saveToken(key: 'random_key', token: 'my_token');

      expect(APIManager.prefs.getString('random_key'), 'my_token');
    });

    test('check delete token is working fine', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token
      await apiManager.saveToken(token: 'my_token');

      /// Delete token
      await apiManager.deleteToken();

      expect(APIManager.prefs.getString('token'), null);
    });

    test('check delete token is working fine for named key', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token with named key
      await apiManager.saveToken(key: 'random_key', token: 'my_token');

      /// Delete token
      await apiManager.deleteToken();

      expect(APIManager.prefs.getString('random_key'), null);
    });

    test('check delete token for named key, only deletes that key and nothing else', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token with named key
      await apiManager.saveToken(key: 'random_key', token: 'my_token');

      /// Save another random key, value pair
      await APIManager.prefs.setString('key', 'value');

      /// Delete token
      await apiManager.deleteToken();

      expect(APIManager.prefs.getString('key'), 'value');
    });

    test('check on saving the null key, assertion error is raised', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      expect(() async => {await apiManager.saveToken()}, throwsAssertionError);
    });

    test('check that on saving the token the prefs get initialized, if not already', () async {
      /// Simulating that the prefs is null
      APIManager.prefs = null;

      /// Save token
      await apiManager.saveToken(token: 'token');

      expect(APIManager.prefs.getString('token'), 'token');
    });

    test('check that on deleting the token the prefs get initialized, if not already', () async {
      /// Create [SharedPreferences] instance
      APIManager.prefs = await SharedPreferences.getInstance();

      /// Save token with named key
      await apiManager.saveToken(token: 'token');

      /// Simulating that the prefs is null
      APIManager.prefs = null;

      /// Save token
      await apiManager.deleteToken();

      expect(APIManager.prefs.getString('token'), null);
    });
  });
}
