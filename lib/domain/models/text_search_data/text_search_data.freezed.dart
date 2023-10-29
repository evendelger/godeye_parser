// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_search_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TextSearchData _$TextSearchDataFromJson(Map<String, dynamic> json) {
  return _TextSearchData.fromJson(json);
}

/// @nodoc
mixin _$TextSearchData {
  int get textSearchId => throw _privateConstructorUsedError;
  String get regionToSearch => throw _privateConstructorUsedError;
  String get controllerText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TextSearchDataCopyWith<TextSearchData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextSearchDataCopyWith<$Res> {
  factory $TextSearchDataCopyWith(
          TextSearchData value, $Res Function(TextSearchData) then) =
      _$TextSearchDataCopyWithImpl<$Res, TextSearchData>;
  @useResult
  $Res call({int textSearchId, String regionToSearch, String controllerText});
}

/// @nodoc
class _$TextSearchDataCopyWithImpl<$Res, $Val extends TextSearchData>
    implements $TextSearchDataCopyWith<$Res> {
  _$TextSearchDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textSearchId = null,
    Object? regionToSearch = null,
    Object? controllerText = null,
  }) {
    return _then(_value.copyWith(
      textSearchId: null == textSearchId
          ? _value.textSearchId
          : textSearchId // ignore: cast_nullable_to_non_nullable
              as int,
      regionToSearch: null == regionToSearch
          ? _value.regionToSearch
          : regionToSearch // ignore: cast_nullable_to_non_nullable
              as String,
      controllerText: null == controllerText
          ? _value.controllerText
          : controllerText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextSearchDataImplCopyWith<$Res>
    implements $TextSearchDataCopyWith<$Res> {
  factory _$$TextSearchDataImplCopyWith(_$TextSearchDataImpl value,
          $Res Function(_$TextSearchDataImpl) then) =
      __$$TextSearchDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int textSearchId, String regionToSearch, String controllerText});
}

/// @nodoc
class __$$TextSearchDataImplCopyWithImpl<$Res>
    extends _$TextSearchDataCopyWithImpl<$Res, _$TextSearchDataImpl>
    implements _$$TextSearchDataImplCopyWith<$Res> {
  __$$TextSearchDataImplCopyWithImpl(
      _$TextSearchDataImpl _value, $Res Function(_$TextSearchDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textSearchId = null,
    Object? regionToSearch = null,
    Object? controllerText = null,
  }) {
    return _then(_$TextSearchDataImpl(
      textSearchId: null == textSearchId
          ? _value.textSearchId
          : textSearchId // ignore: cast_nullable_to_non_nullable
              as int,
      regionToSearch: null == regionToSearch
          ? _value.regionToSearch
          : regionToSearch // ignore: cast_nullable_to_non_nullable
              as String,
      controllerText: null == controllerText
          ? _value.controllerText
          : controllerText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextSearchDataImpl implements _TextSearchData {
  const _$TextSearchDataImpl(
      {required this.textSearchId,
      required this.regionToSearch,
      required this.controllerText});

  factory _$TextSearchDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextSearchDataImplFromJson(json);

  @override
  final int textSearchId;
  @override
  final String regionToSearch;
  @override
  final String controllerText;

  @override
  String toString() {
    return 'TextSearchData(textSearchId: $textSearchId, regionToSearch: $regionToSearch, controllerText: $controllerText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextSearchDataImpl &&
            (identical(other.textSearchId, textSearchId) ||
                other.textSearchId == textSearchId) &&
            (identical(other.regionToSearch, regionToSearch) ||
                other.regionToSearch == regionToSearch) &&
            (identical(other.controllerText, controllerText) ||
                other.controllerText == controllerText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, textSearchId, regionToSearch, controllerText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TextSearchDataImplCopyWith<_$TextSearchDataImpl> get copyWith =>
      __$$TextSearchDataImplCopyWithImpl<_$TextSearchDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TextSearchDataImplToJson(
      this,
    );
  }
}

abstract class _TextSearchData implements TextSearchData {
  const factory _TextSearchData(
      {required final int textSearchId,
      required final String regionToSearch,
      required final String controllerText}) = _$TextSearchDataImpl;

  factory _TextSearchData.fromJson(Map<String, dynamic> json) =
      _$TextSearchDataImpl.fromJson;

  @override
  int get textSearchId;
  @override
  String get regionToSearch;
  @override
  String get controllerText;
  @override
  @JsonKey(ignore: true)
  _$$TextSearchDataImplCopyWith<_$TextSearchDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
