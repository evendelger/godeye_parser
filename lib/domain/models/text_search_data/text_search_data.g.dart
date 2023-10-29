// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_search_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TextSearchDataImpl _$$TextSearchDataImplFromJson(Map<String, dynamic> json) =>
    _$TextSearchDataImpl(
      textSearchId: json['textSearchId'] as int,
      regionToSearch: json['regionToSearch'] as String,
      controllerText: json['controllerText'] as String,
    );

Map<String, dynamic> _$$TextSearchDataImplToJson(
        _$TextSearchDataImpl instance) =>
    <String, dynamic>{
      'textSearchId': instance.textSearchId,
      'regionToSearch': instance.regionToSearch,
      'controllerText': instance.controllerText,
    };
