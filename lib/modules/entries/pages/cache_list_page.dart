import 'package:dictionary/modules/entries/controllers/cache_controller.dart';
import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/widgets/entry_card/entry_card.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CacheListPage extends StatefulWidget {
  const CacheListPage({super.key});

  @override
  State<CacheListPage> createState() => _CacheListPageState();
}

class _CacheListPageState extends State<CacheListPage> {
  final controller = Get.find<CacheController>();

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
          init: Get.find<CacheController>(),
          builder: (_) {
            return Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: [
                        Text(
                          'History',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  if (controller.entries.isEmpty)
                    const Center(
                      child: Text(
                        'There is no word history for your user...',
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
                      showFavoriteIcon: false,
                      entry: controller.entries[index],
                      onTap: () => Get.find<EntryController>().showDetails(
                        controller.entries[index],
                      ),
                    ),
                  )),
                ],
              ),
            );
          }),
    );
  }
}
