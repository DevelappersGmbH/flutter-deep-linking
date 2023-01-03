import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute(
        path: '/country',
        builder: () => const MyHomePage(),
        children: [
          QRoute(
            path: '/:country',
            builder: () => const CountryWidget(),
          ),
        ],
      ),
    ];
    return MaterialApp.router(
      title: 'Country Information App',
      routerDelegate: QRouterDelegate(routes, initPath: '/country'),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _countryName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Information App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter country name',
              ),
              onChanged: (value) {
                _countryName = value;
              },
              onSubmitted: (value) {
                QR.to('/country/$value');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                QR.to('/country/$_countryName');
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryWidget extends StatelessWidget {
  const CountryWidget({super.key});

  Future<Map> _getCountryData() async {
    try {
      final countryName = QR.params['country']?.toString() ?? '';
      print(countryName);
      http.Response response = await http
          .get(Uri.parse('https://restcountries.com/v2/name/$countryName'));
      if (response.statusCode != 200) {
        return {'Error': 'Error ${response.statusCode}'};
      }
      print(response.body);
      Map data = json.decode(response.body).first;

      return data;
    } catch (e) {
      return {'Error': '$e'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: _getCountryData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as Map<dynamic, dynamic>;
          if (data.containsKey('Error')) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text(data['Error']),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Country info'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  for (final key in data.keys)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$key: ${data[key]}'),
                    ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
