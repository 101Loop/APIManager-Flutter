# APIManager-Flutter

[![pub package](https://img.shields.io/pub/v/flutter_api_manager.svg)](https://pub.dev/packages/flutter_api_manager)
![codecov](https://codecov.io/gh/101Loop/APIManager-Flutter/branch/master/graph/badge.svg?token=770R0EZKQG)
![license](https://img.shields.io/github/license/101Loop/APIManager-Flutter.svg)
![pr-welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

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

## Android Compatibility
Since this package is dependent on `flutter_secure_storage` a `minSdkVersion` of 18 is required

android > app > build.gradle
```
android {
    ...

    defaultConfig {
        ...
        minSdkVersion 18
        ...
    }

}
```

## Installation
To install this package, run
> flutter pub add flutter_api_manager

### Usage

Create a singleton and make requests
``` dart
import 'package:flutter_api_manager/flutter_api_manager.dart';

class APIController {
  APIManager _apiManager = APIManager.getInstance(baseUrl: '<your-base-url>');
  
  static fetchResults() {
    _apiManager.request('endPoint', method: APIMethod.get).then((response) {
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

You are always WELCOME! We are excited to see your awesome PRs.

NOTE: Please abide by the
[CODE OF CONDUCT.](https://github.com/101Loop/APIManager-Flutter/blob/master/CODE_OF_CONDUCT.md)
