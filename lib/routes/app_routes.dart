import 'package:country_deep_linking/pages/currencies/currency_widget.dart';
import 'package:country_deep_linking/pages/regions/region_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../pages/currencies/view.dart';
import '../pages/home/view.dart';
import '../pages/regions/view.dart';

class AppRoutes {
  static const String home = '/home';

  static const String currency = 'currencies';
  static const List<String> currencies = ['euro', 'dollar', 'rial'];

  static const String region = 'regions';
  static const List<String> regions = ['asia', 'europe', 'africa', 'america'];

  static String toPath(String name) => '/$name';

  final routes = [
    QRoute(
      name: home,
      path: '/home',
      builder: () => const HomePage(),
      children: [
        QRoute.withChild(
          name: currency,
          path: toPath(currency),
          builderChild: (r) => CurrenciesPage(r),
          initRoute: currencies.first,
          children: [
            for (final currency in currencies)
              QRoute(
                name: currency,
                path: toPath(currency),
                builder: () => CurrencyWidget(currency),
              ),
          ],
        ),
        QRoute.withChild(
          name: region,
          path: toPath(region),
          builderChild: (r) => RegionsPage(r),
          initRoute: regions.first,
          children: [
            for (final region in regions)
              QRoute(
                name: region,
                path: toPath(region),
                builder: () => RegionWidget(region),
              ),
          ],
        ),
      ],
    ),
  ];
}
