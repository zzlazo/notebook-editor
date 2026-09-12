import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';
part 'content.g.dart';

@freezed
abstract class Content with _$Content {
  const factory Content({
    required int id,
    @JsonKey(defaultValue: '') required String title,
    @JsonKey(defaultValue: '') required String body,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Content;

  factory Content.fromJson(Map<String, Object?> json) =>
      _$ContentFromJson(json);
}
