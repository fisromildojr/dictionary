import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/controllers/favorite_controller.dart';
import 'package:dictionary/modules/entries/widgets/entry_card/entry_card.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  final controller = Get.find<FavoriteController>();

  @override
  void initState() {
    controller.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => controller.reload(),
      child: GetBuilder(
          init: Get.find<FavoriteController>(),
          builder: (favoriteController) {
            return Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: [
                        Text(
                          'Favorites',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  if (controller.entries.isEmpty)
                    const Center(
                      child: Text(
                        'There are no favorites for your user...',
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.entries.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) => EntryCard(
                        entry: controller.entries[index],
                        onTap: () => Get.find<EntryController>().showDetails(
                          controller.entries[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
