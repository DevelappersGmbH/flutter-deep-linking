import 'package:country_deep_linking/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class CurrenciesPage extends StatefulWidget {
  final QRouter router;
  const CurrenciesPage(this.router, {super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends RouterState<CurrenciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      body: widget.router,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (var route in AppRoutes.currencies)
            BottomNavigationBarItem(
              label: route,
              icon: const Icon(Icons.currency_exchange),
            ),
        ],
        currentIndex: AppRoutes.currencies.indexOf(widget.router.routeName),
        onTap: (v) => QR.toName(AppRoutes.currencies[v]),
      ),
    );
  }

  @override
  QRouter get router => widget.router;
}
