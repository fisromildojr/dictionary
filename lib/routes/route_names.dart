import 'package:dictionary/storage/app_storage.dart';

String initialRoute =
    AppStorage.instance.user == null ? RouteLoginPage : RouteHomePage;
// String initialRoute = isAuthenticated() ? HomeRoute : LoginPageRoute;
const String RouteLoginPage = '/login';
const String RouteHomePage = '/home';
const String RouteEntryListPage = '/entry-list-page';
const String RouteEntryDetailsPage = '/details';
