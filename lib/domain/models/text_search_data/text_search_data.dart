import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_search_data.freezed.dart';
part 'text_search_data.g.dart';

@freezed
class TextSearchData with _$TextSearchData {
  const factory TextSearchData({
    required int textSearchId,
    required String regionToSearch,
    required String controllerText,
  }) = _TextSearchData;

  factory TextSearchData.fromJson(Map<String, Object?> json) =>
      _$TextSearchDataFromJson(json);
}
