typedef MapList = List<Map<String, List<String>>>;

enum SearchStatus {
  waiting,
  inProgress,
  success,
  error,
}

class PersonStateModel {
  SearchStatus regionStatus = SearchStatus.waiting;
  String? regionToSearch;
  List<String>? regionPhones;

  SearchStatus cityStatus = SearchStatus.waiting;
  List<String>? cityRegionPhones;
  List<String>? cityPhones;

  SearchStatus experienceStatus = SearchStatus.waiting;
  String? experienceToSearch;
  MapList? experienceRegionPhones;
  MapList? experiencePhones;
}
