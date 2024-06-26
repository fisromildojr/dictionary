import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';

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
        child: Column(
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
                child: TabBarView(controller: tabController, children: const [
                  Text('Word list'),
                  Text('History'),
                  Text('Favorites'),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
