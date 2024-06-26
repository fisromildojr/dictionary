// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definitions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Definitions _$DefinitionsFromJson(Map<String, dynamic> json) => Definitions(
      definition: json['definition'] as String?,
      example: json['example'] as String?,
      synonyms: (json['synonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      antonyms: (json['antonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DefinitionsToJson(Definitions instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'example': instance.example,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
    };
