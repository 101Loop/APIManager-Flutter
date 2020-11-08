# APIManager-Flutter

![codecov](https://codecov.io/gh/101Loop/APIManager-Flutter/branch/master/graph/badge.svg?token=770R0EZKQG)
![license](https://img.shields.io/github/license/101Loop/APIManager-Flutter.svg)
![pr-welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![open-source](https://badges.frapsoft.com/os/v1/open-source.png?v=103)

`APIManager-Flutter` is an API manager for flutter applications that can manage
the API calls from a single place.<br>

# Features

Here's the list of your all-in-one service

- [x] Manage token transaction
- [x] Secured token transaction
- [x] Basic CRUD operations
- [x] Upload file
- [ ] Download file
- [ ] Enable logging
- [ ] Support Multi environment base url

## Usage
To use this package, add `flutter_api_manager` as a dependency in your `pubspec.yaml` file.
``` dart
...
flutter_api_manager:
  path: <path_to_root_folder>
...
```
### Example

Create a singleton and make requests
``` dart
import 'package:flutter_api_manager/flutter_api_manager.dart';

class APIController {
  APIManager _apiManager = APIManager(baseUrl: '<your-base-url>');
  
  static fetchResults() {
    _apiManager.makeRequest('endPoint', APIMethod.get).then((response) {
      ...    
    });
  }
  
  static uploadFile(File imageFile, String fileKey, Map data,) {
    _apiManager.uploadFile('endPoint', imageFile, fileKey, data: data).then((response) {
      ...    
    });
  }
}
```
Login once to set the token throughout the app
```dart
...
  static login() {
    String token = _getToken();
    _apiManager.login(token);
  }
...
```
Logout when you want to clear the token
```dart
...
  static logout() {
    _apiManager.logout();
  }
...
```

## Want to Contribute

[Here's a way to start contributing](https://github.com/101Loop/APIManager-Flutter/blob/master/CONTRIBUTING.md)

You are always WELCOME! We are are excited to see your awesome PRs.

NOTE: Please abide by the
[CODE OF CONDUCT.](https://github.com/101Loop/APIManager-Flutter/blob/master/CODE_OF_CONDUCT.md)

## Author & Maintainer ✒️

[Dipanshu](https://github.com/iamdipanshusingh)
