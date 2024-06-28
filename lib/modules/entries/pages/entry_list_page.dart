import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
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
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => controller.reload(),
      child: Column(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => Material(
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () =>
                          controller.showDetails(controller.entries[index]),
                      child: Container(
                        margin: const EdgeInsets.all(defaultPadding / 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            controller.entries[index].word ?? 'No word',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
