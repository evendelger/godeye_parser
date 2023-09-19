class PersonStateModel {
  const PersonStateModel({required this.peopleData});

  final List<DatePhoneModel> peopleData;
}

class DatePhoneModel {
  const DatePhoneModel({
    required this.dateOfBirth,
    this.correctedPhones,
  });

  final DateTime dateOfBirth;
  final List<String>? correctedPhones;
}
