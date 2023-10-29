// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_search_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileSearchDataImpl _$$FileSearchDataImplFromJson(Map<String, dynamic> json) =>
    _$FileSearchDataImpl(
      fileSearchId: json['fileSearchId'] as int,
      regionToSearch: json['regionToSearch'] as String,
      nameControllerText: json['nameControllerText'] as String,
      cityControllerText: json['cityControllerText'] as String,
      experienceControllerText: json['experienceControllerText'] as String,
    );

Map<String, dynamic> _$$FileSearchDataImplToJson(
        _$FileSearchDataImpl instance) =>
    <String, dynamic>{
      'fileSearchId': instance.fileSearchId,
      'regionToSearch': instance.regionToSearch,
      'nameControllerText': instance.nameControllerText,
      'cityControllerText': instance.cityControllerText,
      'experienceControllerText': instance.experienceControllerText,
    };
