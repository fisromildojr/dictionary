import 'package:dictionary/modules/entries/models/definitions_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meanings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Meanings {
  String? partOfSpeech;
  List<Definitions>? definitions;

  Meanings({
    this.partOfSpeech,
    this.definitions,
  });

  factory Meanings.fromJson(Map<String, dynamic> json) =>
      _$MeaningsFromJson(json);

  Map<String, dynamic> toJson() => _$MeaningsToJson(this);
}
