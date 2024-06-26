import 'package:json_annotation/json_annotation.dart';

part 'phonetics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Phonetics {
  String? text;
  String? audio;

  Phonetics({this.text, this.audio});

  factory Phonetics.fromJson(Map<String, dynamic> json) =>
      _$PhoneticsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneticsToJson(this);
}
