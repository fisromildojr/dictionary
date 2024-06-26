// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meanings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meanings _$MeaningsFromJson(Map<String, dynamic> json) => Meanings(
      partOfSpeech: json['partOfSpeech'] as String?,
      definitions: (json['definitions'] as List<dynamic>?)
          ?.map((e) => Definitions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeaningsToJson(Meanings instance) => <String, dynamic>{
      'partOfSpeech': instance.partOfSpeech,
      'definitions': instance.definitions?.map((e) => e.toJson()).toList(),
    };
