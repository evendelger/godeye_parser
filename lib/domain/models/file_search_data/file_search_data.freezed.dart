// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_search_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FileSearchData _$FileSearchDataFromJson(Map<String, dynamic> json) {
  return _FileSearchData.fromJson(json);
}

/// @nodoc
mixin _$FileSearchData {
  int get fileSearchId => throw _privateConstructorUsedError;
  String get regionToSearch => throw _privateConstructorUsedError;
  String get nameControllerText => throw _privateConstructorUsedError;
  String get cityControllerText => throw _privateConstructorUsedError;
  String get experienceControllerText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FileSearchDataCopyWith<FileSearchData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileSearchDataCopyWith<$Res> {
  factory $FileSearchDataCopyWith(
          FileSearchData value, $Res Function(FileSearchData) then) =
      _$FileSearchDataCopyWithImpl<$Res, FileSearchData>;
  @useResult
  $Res call(
      {int fileSearchId,
      String regionToSearch,
      String nameControllerText,
      String cityControllerText,
      String experienceControllerText});
}

/// @nodoc
class _$FileSearchDataCopyWithImpl<$Res, $Val extends FileSearchData>
    implements $FileSearchDataCopyWith<$Res> {
  _$FileSearchDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileSearchId = null,
    Object? regionToSearch = null,
    Object? nameControllerText = null,
    Object? cityControllerText = null,
    Object? experienceControllerText = null,
  }) {
    return _then(_value.copyWith(
      fileSearchId: null == fileSearchId
          ? _value.fileSearchId
          : fileSearchId // ignore: cast_nullable_to_non_nullable
              as int,
      regionToSearch: null == regionToSearch
          ? _value.regionToSearch
          : regionToSearch // ignore: cast_nullable_to_non_nullable
              as String,
      nameControllerText: null == nameControllerText
          ? _value.nameControllerText
          : nameControllerText // ignore: cast_nullable_to_non_nullable
              as String,
      cityControllerText: null == cityControllerText
          ? _value.cityControllerText
          : cityControllerText // ignore: cast_nullable_to_non_nullable
              as String,
      experienceControllerText: null == experienceControllerText
          ? _value.experienceControllerText
          : experienceControllerText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileSearchDataImplCopyWith<$Res>
    implements $FileSearchDataCopyWith<$Res> {
  factory _$$FileSearchDataImplCopyWith(_$FileSearchDataImpl value,
          $Res Function(_$FileSearchDataImpl) then) =
      __$$FileSearchDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fileSearchId,
      String regionToSearch,
      String nameControllerText,
      String cityControllerText,
      String experienceControllerText});
}

/// @nodoc
class __$$FileSearchDataImplCopyWithImpl<$Res>
    extends _$FileSearchDataCopyWithImpl<$Res, _$FileSearchDataImpl>
    implements _$$FileSearchDataImplCopyWith<$Res> {
  __$$FileSearchDataImplCopyWithImpl(
      _$FileSearchDataImpl _value, $Res Function(_$FileSearchDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileSearchId = null,
    Object? regionToSearch = null,
    Object? nameControllerText = null,
    Object? cityControllerText = null,
    Object? experienceControllerText = null,
  }) {
    return _then(_$FileSearchDataImpl(
      fileSearchId: null == fileSearchId
          ? _value.fileSearchId
          : fileSearchId // ignore: cast_nullable_to_non_nullable
              as int,
      regionToSearch: null == regionToSearch
          ? _value.regionToSearch
          : regionToSearch // ignore: cast_nullable_to_non_nullable
              as String,
      nameControllerText: null == nameControllerText
          ? _value.nameControllerText
          : nameControllerText // ignore: cast_nullable_to_non_nullable
              as String,
      cityControllerText: null == cityControllerText
          ? _value.cityControllerText
          : cityControllerText // ignore: cast_nullable_to_non_nullable
              as String,
      experienceControllerText: null == experienceControllerText
          ? _value.experienceControllerText
          : experienceControllerText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileSearchDataImpl implements _FileSearchData {
  const _$FileSearchDataImpl(
      {required this.fileSearchId,
      required this.regionToSearch,
      required this.nameControllerText,
      required this.cityControllerText,
      required this.experienceControllerText});

  factory _$FileSearchDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileSearchDataImplFromJson(json);

  @override
  final int fileSearchId;
  @override
  final String regionToSearch;
  @override
  final String nameControllerText;
  @override
  final String cityControllerText;
  @override
  final String experienceControllerText;

  @override
  String toString() {
    return 'FileSearchData(fileSearchId: $fileSearchId, regionToSearch: $regionToSearch, nameControllerText: $nameControllerText, cityControllerText: $cityControllerText, experienceControllerText: $experienceControllerText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileSearchDataImpl &&
            (identical(other.fileSearchId, fileSearchId) ||
                other.fileSearchId == fileSearchId) &&
            (identical(other.regionToSearch, regionToSearch) ||
                other.regionToSearch == regionToSearch) &&
            (identical(other.nameControllerText, nameControllerText) ||
                other.nameControllerText == nameControllerText) &&
            (identical(other.cityControllerText, cityControllerText) ||
                other.cityControllerText == cityControllerText) &&
            (identical(
                    other.experienceControllerText, experienceControllerText) ||
                other.experienceControllerText == experienceControllerText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fileSearchId, regionToSearch,
      nameControllerText, cityControllerText, experienceControllerText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FileSearchDataImplCopyWith<_$FileSearchDataImpl> get copyWith =>
      __$$FileSearchDataImplCopyWithImpl<_$FileSearchDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileSearchDataImplToJson(
      this,
    );
  }
}

abstract class _FileSearchData implements FileSearchData {
  const factory _FileSearchData(
      {required final int fileSearchId,
      required final String regionToSearch,
      required final String nameControllerText,
      required final String cityControllerText,
      required final String experienceControllerText}) = _$FileSearchDataImpl;

  factory _FileSearchData.fromJson(Map<String, dynamic> json) =
      _$FileSearchDataImpl.fromJson;

  @override
  int get fileSearchId;
  @override
  String get regionToSearch;
  @override
  String get nameControllerText;
  @override
  String get cityControllerText;
  @override
  String get experienceControllerText;
  @override
  @JsonKey(ignore: true)
  _$$FileSearchDataImplCopyWith<_$FileSearchDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
