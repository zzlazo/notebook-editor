import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_content_dto.freezed.dart';
part 'create_content_dto.g.dart';

@freezed
abstract class CreateContentDTO with _$CreateContentDTO {
  const factory CreateContentDTO({
    required String title,
    required String body,
  }) = _CreateContentDTO;

  factory CreateContentDTO.fromJson(Map<String, Object?> json) =>
      _$CreateContentDTOFromJson(json);
}
