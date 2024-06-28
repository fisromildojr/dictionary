import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/pages/cache_list_page.dart';
import 'package:dictionary/modules/entries/pages/entry_list_page.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final tabLength = 3;

  @override
  void initState() {
    tabController = TabController(length: tabLength, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Get.find<EntryController>().isLoadingSync.isTrue
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Insert initial data...'),
                      Stack(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              value: Get.find<EntryController>()
                                      .progressSync
                                      .value /
                                  100,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${(Get.find<EntryController>().progressSync.value).toStringAsFixed(2)}%',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: TabBar(
                        controller: tabController,
                        tabs: const [
                          Tab(
                            text: 'Word list',
                          ),
                          Tab(
                            text: 'History',
                          ),
                          Tab(
                            text: 'Favorites',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: TabBarView(
                            controller: tabController,
                            children: const [
                              EntryListPage(),
                              CacheListPage(),
                              Text('Favorites'),
                            ]),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
