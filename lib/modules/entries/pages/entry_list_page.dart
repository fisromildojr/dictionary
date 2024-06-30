import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/controllers/favorite_controller.dart';
import 'package:dictionary/modules/entries/widgets/entry_card/entry_card.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<EntryListPage> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  final controller = Get.find<EntryController>();

  @override
  void initState() {
    Get.put(FavoriteController());
    controller.findAllPaginated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => controller.reload(),
      child: GetBuilder(
          init: Get.find<EntryController>(),
          builder: (_) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    children: [
                      Text(
                        'Word list',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => GridView.builder(
                        shrinkWrap: true,
                        controller: controller.scrollController,
                        itemCount: controller.entries.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => EntryCard(
                          entry: controller.entries[index],
                          onTap: () => controller.showDetails(
                            controller.entries[index],
                          ),
                        ),
                      )),
                ),
              ],
            );
          }),
    );
  }
}
