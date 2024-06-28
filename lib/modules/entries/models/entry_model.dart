import 'package:dictionary/modules/entries/models/meanings_model.dart';
import 'package:dictionary/modules/entries/models/phonetics_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Entry {
  int? id;
  String? word;
  String? phonetic;
  List<Phonetics>? phonetics;
  String? origin;
  List<Meanings>? meanings;

  Entry({
    this.word,
    this.phonetic,
    this.phonetics,
    this.origin,
    this.meanings,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);
}
