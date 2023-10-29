import 'package:equatable/equatable.dart';

typedef MapList = List<Map<String, List<String>>>;

enum SearchStatus {
  waiting,
  inProgress,
  success,
  error,
}

class PersonStateModel {
  var statuses = const Statuses(
    regionStatus: SearchStatus.waiting,
    cityStatus: SearchStatus.waiting,
    experienceStatus: SearchStatus.waiting,
  );

  String? regionToSearch;
  List<String>? regionPhones;

  List<String>? cityRegionPhones;
  List<String>? cityPhones;

  String? experienceToSearch;
  MapList? experienceRegionPhones;
  MapList? experiencePhones;
  List<String>? regionPhonesWithoutDate;
  List<String>? phonesWithoutDate;
}

class Statuses extends Equatable {
  const Statuses({
    required this.regionStatus,
    required this.cityStatus,
    required this.experienceStatus,
  });

  final SearchStatus regionStatus;
  final SearchStatus cityStatus;
  final SearchStatus experienceStatus;

  // ignore: prefer_const_constructors
  factory Statuses.init() => Statuses(
        regionStatus: SearchStatus.waiting,
        cityStatus: SearchStatus.waiting,
        experienceStatus: SearchStatus.waiting,
      );

  @override
  List<Object?> get props => [regionStatus, cityStatus, experienceStatus];

  Statuses copyWith({
    SearchStatus? regionStatus,
    SearchStatus? cityStatus,
    SearchStatus? experienceStatus,
  }) {
    return Statuses(
      regionStatus: regionStatus ?? this.regionStatus,
      cityStatus: cityStatus ?? this.cityStatus,
      experienceStatus: experienceStatus ?? this.experienceStatus,
    );
  }
}
