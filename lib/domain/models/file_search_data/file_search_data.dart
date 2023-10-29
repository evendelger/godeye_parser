import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_search_data.freezed.dart';
part 'file_search_data.g.dart';

@freezed
class FileSearchData with _$FileSearchData {
  const factory FileSearchData({
    required int fileSearchId,
    required String regionToSearch,
    required String nameControllerText,
    required String cityControllerText,
    required String experienceControllerText,
  }) = _FileSearchData;
  factory FileSearchData.empty() => _FileSearchData(
        fileSearchId: -1,
        regionToSearch: '',
        nameControllerText: '',
        cityControllerText: '',
        experienceControllerText: '',
      );

  factory FileSearchData.fromJson(Map<String, Object?> json) =>
      _$FileSearchDataFromJson(json);
}
