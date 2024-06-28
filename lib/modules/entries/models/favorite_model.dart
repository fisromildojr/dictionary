import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Favorite {
  int? id;

  @JsonKey(name: 'entry_id')
  int? entryId;

  @JsonKey(name: 'user_id')
  int? userId;

  Favorite({
    this.id,
    this.entryId,
    this.userId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
