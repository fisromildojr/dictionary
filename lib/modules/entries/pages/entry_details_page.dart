import 'dart:developer';

import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/services/entry_service.dart';
import 'package:dictionary/modules/entries/widgets/audio_player_widget/audio_player_widget.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryDetailsPage extends StatefulWidget {
  const EntryDetailsPage({super.key});

  @override
  State<EntryDetailsPage> createState() => _EntryDetailsPageState();
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final _isLoading = false.obs;
  Entry? entry = Get.arguments;
  final controller = Get.find<EntryController>();

  findWord() async {
    if (entry == null) return;
    try {
      _isLoading(true);
      entry = await EntryService().findWord(entry!.word!);
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading(false);
    }
  }

  @override
  void initState() {
    findWord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => _isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(230, 208, 222, 1.0),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  entry?.word ??
                                      'Sorry, the word was not found...',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (entry?.phonetic != null)
                                  Text(
                                    entry!.phonetic!,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (entry?.phonetics?.any(
                            (e) => e.audio != null && e.audio!.isNotEmpty) ??
                        false)
                      Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Pronunciations',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          ...entry!.phonetics!.map((e) {
                            if (e.audio != null && e.audio!.isNotEmpty) {
                              return AudioPlayerWidget(audioUrl: e.audio!);
                            }
                            return Container();
                          }),
                        ],
                      ),
                    if (entry?.meanings != null)
                      Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Meanings',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          ...entry!.meanings!.map((e) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      (e.partOfSpeech != null &&
                                                  e.partOfSpeech!.isNotEmpty
                                              ? '${e.partOfSpeech} - '
                                              : '') +
                                          (e.definitions?.first.definition ??
                                              'No definition'),
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
