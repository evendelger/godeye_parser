import 'package:godeye_parser/domain/models/models.dart';

class ModelParsing {
  static List<FileSearchData> parseFileSearchData(
      List<Map<String, dynamic>> dataList) {
    final fileSearchList = <FileSearchData>[];
    for (final dataMap in dataList) {
      final recipe = FileSearchData.fromJson(dataMap);
      fileSearchList.add(recipe);
    }
    return fileSearchList;
  }

  static List<TextSearchData> parseTextSearchData(
      List<Map<String, dynamic>> dataList) {
    final textSearchList = <TextSearchData>[];
    for (final dataMap in dataList) {
      final ingredient = TextSearchData.fromJson(dataMap);
      textSearchList.add(ingredient);
    }
    return textSearchList;
  }
}
