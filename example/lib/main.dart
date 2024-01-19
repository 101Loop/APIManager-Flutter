import 'package:flutter/material.dart';
import 'package:flutter_api_manager/flutter_api_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  Response? response;

  @override
  void initState() {
    super.initState();

    final _apiManager = APIManager.getInstance(baseUrl: 'https://reqres.in');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        response = await _apiManager.request('/api/users/4');
        setState(() {});
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Text(response!.data.toString()),
        ),
      ),
    );
  }
}
