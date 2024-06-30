// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    this.id,
    this.word,
    this.phonetic,
    this.phonetics,
    this.origin,
    this.meanings,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);

  Entry copyWith({
    int? id,
    String? word,
    String? phonetic,
    List<Phonetics>? phonetics,
    String? origin,
    List<Meanings>? meanings,
  }) {
    return Entry(
      id: id ?? this.id,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      phonetics: phonetics ?? this.phonetics,
      origin: origin ?? this.origin,
      meanings: meanings ?? this.meanings,
    );
  }
}
