import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_content_dto.freezed.dart';
part 'update_content_dto.g.dart';

@freezed
abstract class UpdateContentDTO with _$UpdateContentDTO {
  const factory UpdateContentDTO({
    required String title,
    required String body,
  }) = _UpdateContentDTO;

  factory UpdateContentDTO.fromJson(Map<String, Object?> json) =>
      _$UpdateContentDTOFromJson(json);
}
