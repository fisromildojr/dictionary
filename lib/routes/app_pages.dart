import 'package:dictionary/modules/entries/bindings/entry_binding.dart';
import 'package:dictionary/modules/entries/pages/entry_details_page.dart';
import 'package:dictionary/modules/home/pages/home_page.dart';
import 'package:dictionary/modules/user/bindings/user_binding.dart';
import 'package:dictionary/modules/user/pages/login_page.dart';
import 'package:dictionary/routes/route_names.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: RouteLoginPage,
      page: () => const LoginPage(),
      bindings: [
        UserBinding(),
        EntryBinding(),
      ],
    ),
    GetPage(
      name: RouteHomePage,
      page: () => const HomePage(),
      binding: EntryBinding(),
    ),
    GetPage(
      name: RouteEntryDetailsPage,
      page: () => const EntryDetailsPage(),
      binding: EntryBinding(),
    ),
  ];
}
