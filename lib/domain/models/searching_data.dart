class FullSearchingData {
  const FullSearchingData(this.controllers, this.textItem);

  final List<FileSearchingDataItem> controllers;
  final TextSearchingDataItem textItem;

  factory FullSearchingData.init() {
    return FullSearchingData(
      List<FileSearchingDataItem>.generate(
        5,
        (_) => FileSearchingDataItem(),
        growable: true,
      ),
      TextSearchingDataItem(),
    );
  }

  void clearList() {
    controllers.clear();
    controllers.addAll(List<FileSearchingDataItem>.generate(
      5,
      (_) => FileSearchingDataItem(),
      growable: true,
    ));
  }

  void addItems(int length) {
    if (length == 1) {
      controllers.add(FileSearchingDataItem());
    } else {
      controllers.addAll(List<FileSearchingDataItem>.generate(
        length,
        (_) => FileSearchingDataItem(),
        growable: true,
      ));
    }
  }
}

class MiniSearchingData {
  const MiniSearchingData(this.controllers);

  final FileSearchingDataItem controllers;

  factory MiniSearchingData.init() {
    return MiniSearchingData(FileSearchingDataItem());
  }
}

class FileSearchingDataItem {
  FileSearchingDataItem({
    this.regionToSearch = '',
    this.nameControllerText = '',
    this.cityControllerText = '',
    this.experienceControllerText = '',
  });

  String regionToSearch;

  String nameControllerText;
  String cityControllerText;
  String experienceControllerText;

  @override
  String toString() {
    return "region - $regionToSearch, name - $nameControllerText, city - $cityControllerText, exp - $experienceControllerText\n";
  }
}

class TextSearchingDataItem {
  TextSearchingDataItem({
    this.regionToSearch = '',
    this.controllerText = '',
  });

  String regionToSearch;
  String controllerText;
}
