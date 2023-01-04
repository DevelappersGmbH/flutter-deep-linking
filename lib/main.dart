import 'package:country_deep_linking/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  QR.settings.pagesType = const QFadePage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Country Information App',
      routerDelegate: QRouterDelegate(AppRoutes().routes, initPath: '/home'),
      routeInformationParser: const QRouteInformationParser(),
    );
  }
}
