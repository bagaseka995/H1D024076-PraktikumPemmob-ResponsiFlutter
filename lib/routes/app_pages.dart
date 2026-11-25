import 'package:get/get.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/search/search_binding.dart';
import '../modules/search/search_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.home;

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
