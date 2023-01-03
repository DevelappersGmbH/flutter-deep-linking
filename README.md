# Implementing Deep Linking in Flutter Using the qlevar_router Package

Deep linking in Flutter refers to the ability to link to specific pages or content within an app. This allows users to share links to specific content within an app, rather than just the app's homepage. Deep linking can improve user experience by allowing users to easily access the content they want without having to navigate through the app to find it.

One way to implement deep linking in Flutter is by using the qlevar_router package. This package provides a simple and powerful routing system for Flutter apps.
In this article, we will look at how to implement deep linking in Flutter using the qlevar_router package by creating a simple app that displays information about countries by their name.

we will use [restcountries api](https://restcountries.com) to get the data of the countries.
To use qlevar_router, first add it to your pubspec.yaml file and then define the routes for your app.

```yaml
dependencies:
  qlevar_router: ^1.7.1
```

Then define the routes for your app:

```dart
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
```

The above code defines two routes:

- The first route is the home route which just contains a search field to enter the country name and then redirect to the second page.
- The second route is the country route, which displays information about a specific country. The country route is a child route of the home route and has a parameter called country, which is used to define the name of the country.

Next, we need to initialize the router and set the home route for the app to 'country':

```dart
return MaterialApp.router(
  title: 'Country Information App',
  routerDelegate: QRouterDelegate(routes, initPath: '/country'),
  routeInformationParser: const QRouteInformationParser(),
);
```

after defining the pages, we need to [enable deep linking for the app](https://docs.flutter.dev/development/ui/navigation/deep-linking). 


## Enabling Deep Linking in Android

To do this for android , we need to add the following code to the AndroidManifest.xml file in `activity` tag:

```xml
<meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" android:host="develappers.de" />
    <data android:scheme="https" />
</intent-filter>
```

The above code enables deep linking for the app and defines the scheme and host for the app. The scheme is the protocol used to open the app, and the host is the domain name of the app. The host name can be any name you want, but it must be unique. 

Now we can test the app by running the following command in the terminal after running the app on a device or emulator:

```bash
adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "http://develappers.de/country/germany" com.example.country_deep_linking
```

The above command will open the app and navigate to the country route with the parameter country set to germany. The app will then display information about Germany.

## Enabling Deep Linking in iOS

To enable deep linking in iOS, we need to add the following code to the Info.plist file:

```xml
<key>FlutterDeepLinkingEnabled</key>
<true />
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>develappers.de</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>app</string>
		</array>
	</dict>
</array>
```

Then we can test the app by running the following command in the terminal after running the app on a device or emulator:

```bash
xcrun simctl openurl booted "app://develappers.de/country/germany"
```

The above command will open the app and navigate to the country route with the parameter country set to germany. The app will then display information about Germany.

## Web application

you can use the same code for web application. run the app on the web and then add the shown url in the browser `/country/germany` and the app will navigate to the country route with the parameter country set to germany. The app will then display information about Germany.

## Conclusion

In this article, we looked at how to implement deep linking in Flutter using the qlevar_router package. We created a simple app that displays information about countries by their name. We then enabled deep linking for the app and tested it on Android and iOS devices and web application. You can find the full code for the app on [GitHub]().