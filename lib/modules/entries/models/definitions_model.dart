import 'package:json_annotation/json_annotation.dart';

part 'definitions_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Definitions {
  String? definition;
  String? example;
  List<String>? synonyms;
  List<String>? antonyms;

  Definitions({
    this.definition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  factory Definitions.fromJson(Map<String, dynamic> json) =>
      _$DefinitionsFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionsToJson(this);
}
