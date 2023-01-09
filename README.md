# TabBar and BottomNavigationBar in flutter with qlevar_router

In the world of mobile app development, navigation is a crucial aspect that helps users navigate through the app and access different pages and features. In Flutter, two popular options for navigation are the TabBar and BottomNavigationBar. Both of these widgets provide a way to display multiple options in a horizontal strip at the bottom of the screen, but they have some differences that make them suitable for different scenarios.

Using these widgets with a routing system could be a bit tricky, but the qlevar_router package makes it easy to implement them in your app. In this article, we will look at how to implement TabBar and BottomNavigationBar in Flutter using the qlevar_router package by creating a simple app that displays information about countries by region and currency.

we will use [restcountries api](https://restcountries.com) to get the data of the countries.

## Routes definition

First, we need to define the routes for our app. We will have two routes:

- The first route is the home route which contains a TabBar widget with four tabs, one for each region.
- The second route is the currency route, which contains a BottomNavigationBar widget with three tabs, one for each currency.

```dart
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

```

Our main page is the home page, where the user can go to the regions page or the currencies page, and it has two children, one for each page. 
The regions page and the currencies page should be `QRoute.withChild`, so we could define a nested router for each page. where we can update a specific part of the page when the user navigates to a different route.

For Example, when the user navigates from the euro tab to the dollar tab, we need to update just the list of countries in the currencies page, and not the whole page.

When we define a route with `QRoute.withChild`, the builderChild function will be called to build the page. The builderChild function will be called with a `QRouter` object, which is the router for the child routes. We can use this router to display to the child routes in the page in any position we want.

## TabBar

our regions page will be a stateful widget that contains a `QRouter` object and a `TabController`, We will use the `QRouter` object to display the child routes in the page. and the `TabController` to update the selected tab when the user navigates to a different route.

```dart
class RegionsPage extends StatefulWidget {
  final QRouter router;
  const RegionsPage(this.router, {super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppRoutes.regions.length,
      vsync: this,
    );

    // Add listener to update the selected tab when the route changes
    // from outside of this widget.
    widget.router.navigator.addListener(_updateTab);
    // Update the selected tab at start, in case the route was not the default route.
    _updateTab();
  }

  void _updateTab() {
    _tabController.animateTo(
      AppRoutes.regions.indexOf(widget.router.navigator.currentRoute.name!),
    );
  }

  @override
  void dispose() {
    widget.router.navigator.removeListener(_updateTab);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) {
            QR.toName(AppRoutes.regions[value]);
          },
          tabs: AppRoutes.regions.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: widget.router,
    );
  }
}

```

Now when the user navigates to the regions page, the `RegionsPage` widget will be built, and the `TabController` will be initialized with the current route name, which is the defined with `initRoute` in the routes.
When the user navigates to a different child of the regions page, the `widget.router` will be updated with the new route, and the `TabController` will be updated with the new selected route.

## BottomNavigationBar

Implementing the currencies page is easier than the regions page, because we here we can use the `RouterState` class from the qlevar_router package to update the selected tab when the user navigates to a different route.
all we need to do is to provide the `QRouter` to the `RouterState` class.

```dart

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
  // provide the router to the state
  QRouter get router => widget.router;
}

```

and that is it. you can use the same approach to implement a NavigationRail. See the [example here](https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/nav_rail.dart).

## Deep linking

Using qlevar_router enables you to use deep linking out of the box in your app. without any extra configuration. you can open any tap in your app by using the url scheme.
After enabling deep linking in your app, you can run this command to test the deep linking in your app.

```bash
adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "http://develappers.de/home/regions/africa" com.example.country_deep_linking
```

This will open the app and navigate to the africa tab in the regions page. read more about deep linking with qlevar_router [here]().

## Conclusion

In this article, we learned how to implement a nested router in a flutter app using qlevar_router. We learned how to use the `QRoute.withChild` to define a nested router, and how to use the `QRouter` object to display the child routes in the page. We also learned how to use the `TabController` and the `RouterState` class to update the selected tab when the user navigates to a different route. and we learned how to use deep linking to open any tab in the app.

