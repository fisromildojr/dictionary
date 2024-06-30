import 'package:dictionary/modules/entries/controllers/favorite_controller.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryCard extends StatelessWidget {
  EntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.showFavoriteIcon,
  });

  final Entry entry;
  final Function()? onTap;
  bool? showFavoriteIcon = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Stack(
          children: [
            Container(
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
                  entry.word ?? 'No word',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (showFavoriteIcon != false)
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Get.find<FavoriteController>().isFavorite(entry.id!)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Get.find<FavoriteController>().isFavorite(entry.id!)
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () =>
                      Get.find<FavoriteController>().toggleFavorite(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
