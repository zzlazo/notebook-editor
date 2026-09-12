// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_content_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateContentDTO {

 String get title; String get body;
/// Create a copy of CreateContentDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateContentDTOCopyWith<CreateContentDTO> get copyWith => _$CreateContentDTOCopyWithImpl<CreateContentDTO>(this as CreateContentDTO, _$identity);

  /// Serializes this CreateContentDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateContentDTO;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateContentDTO&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateContentDTO;
  return Object.hash(runtimeType,_this.title,_this.body);
}

@override
String toString() {
  final _this = this as CreateContentDTO;
  return 'CreateContentDTO(title: ${_this.title}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $CreateContentDTOCopyWith<$Res>  {
  factory $CreateContentDTOCopyWith(CreateContentDTO value, $Res Function(CreateContentDTO) _then) = _$CreateContentDTOCopyWithImpl;
@useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class _$CreateContentDTOCopyWithImpl<$Res>
    implements $CreateContentDTOCopyWith<$Res> {
  _$CreateContentDTOCopyWithImpl(this._self, this._then);

  final CreateContentDTO _self;
  final $Res Function(CreateContentDTO) _then;

/// Create a copy of CreateContentDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,}) {
  return _then(CreateContentDTO(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateContentDTO].
extension CreateContentDTOPatterns on CreateContentDTO {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateContentDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateContentDTO() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateContentDTO value)  $default,){
final _that = this;
switch (_that) {
case _CreateContentDTO():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateContentDTO value)?  $default,){
final _that = this;
switch (_that) {
case _CreateContentDTO() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateContentDTO() when $default != null:
return $default(_that.title,_that.body);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _CreateContentDTO():
return $default(_that.title,_that.body);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _CreateContentDTO() when $default != null:
return $default(_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateContentDTO implements CreateContentDTO {
  const _CreateContentDTO({required this.title, required this.body});
  factory _CreateContentDTO.fromJson(Map<String, dynamic> json) => _$CreateContentDTOFromJson(json);

@override final  String title;
@override final  String body;

/// Create a copy of CreateContentDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateContentDTOCopyWith<_CreateContentDTO> get copyWith => __$CreateContentDTOCopyWithImpl<_CreateContentDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateContentDTOToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateContentDTO&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,body);
}

@override
String toString() {
    return 'CreateContentDTO(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$CreateContentDTOCopyWith<$Res> implements $CreateContentDTOCopyWith<$Res> {
  factory _$CreateContentDTOCopyWith(_CreateContentDTO value, $Res Function(_CreateContentDTO) _then) = __$CreateContentDTOCopyWithImpl;
@override @useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class __$CreateContentDTOCopyWithImpl<$Res>
    implements _$CreateContentDTOCopyWith<$Res> {
  __$CreateContentDTOCopyWithImpl(this._self, this._then);

  final _CreateContentDTO _self;
  final $Res Function(_CreateContentDTO) _then;

/// Create a copy of CreateContentDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,}) {
  return _then(_CreateContentDTO(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
