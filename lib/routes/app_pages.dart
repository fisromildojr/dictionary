import 'package:dictionary/modules/entries/bindings/budget_binding.dart';
import 'package:dictionary/modules/entries/pages/entry_list_page.dart';
import 'package:dictionary/modules/home/pages/home_page.dart';
import 'package:dictionary/routes/route_names.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: RouteHomePage,
      page: () => const HomePage(),
    ),
    ...routesEntries,
  ];

  static final routesEntries = [
    GetPage(
      name: RouteEntryListPage,
      page: () => const EntryListPage(),
      binding: EntryBinding(),
    ),
  ];
}
