class SearchingDataList {
  const SearchingDataList(this.listOfControllers);

  final List<SearchingDataItem> listOfControllers;

  factory SearchingDataList.init() {
    return SearchingDataList(List<SearchingDataItem>.filled(
      5,
      SearchingDataItem(),
      growable: true,
    ));
  }

  void addItems(int length) {
    if (length == 1) {
      listOfControllers.add(SearchingDataItem());
    } else {
      listOfControllers.addAll(List<SearchingDataItem>.filled(
        length,
        SearchingDataItem(),
        growable: true,
      ));
    }
  }
}

class SearchingDataItem {
  SearchingDataItem({
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
