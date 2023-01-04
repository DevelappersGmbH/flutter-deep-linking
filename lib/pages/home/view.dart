import 'package:country_deep_linking/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Information App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => QR.toName(AppRoutes.currency),
              child: const Text('Countries by Currency'),
            ),
            TextButton(
              onPressed: () => QR.toName(AppRoutes.region),
              child: const Text('Countries by Regin'),
            ),
          ],
        ),
      ),
    );
  }
}
