class SearchingDataList {
  const SearchingDataList(this.listOfControllers, this.textItem);

  final List<FileSearchingDataItem> listOfControllers;
  final TextSearchingDataItem textItem;

  factory SearchingDataList.init() {
    return SearchingDataList(
      List<FileSearchingDataItem>.generate(
        5,
        (_) => FileSearchingDataItem(),
        growable: true,
      ),
      TextSearchingDataItem(),
    );
  }

  void clearList() {
    listOfControllers.clear();
    listOfControllers.addAll(List<FileSearchingDataItem>.generate(
      5,
      (_) => FileSearchingDataItem(),
      growable: true,
    ));
  }

  void addItems(int length) {
    if (length == 1) {
      listOfControllers.add(FileSearchingDataItem());
    } else {
      listOfControllers.addAll(List<FileSearchingDataItem>.generate(
        length,
        (_) => FileSearchingDataItem(),
        growable: true,
      ));
    }
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
