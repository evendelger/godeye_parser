class SinglePersonModel {
  SinglePersonModel({
    String? phone,
    String? adress,
    DateTime? dateOfBirth,
  }) {
    addDate(dateOfBirth);
    addPhone(phone);
    addAdress(adress);
  }

  DateTime? dateOfBirth;
  Set<String> adressesList = {};
  Set<String> phoneNumbersList = {};

  void addDate(DateTime? date) {
    dateOfBirth ??= date;
  }

  void addPhone(String? phone) {
    if (phone != null) {
      phoneNumbersList.add(phone);
    }
  }

  void addAdress(String? adress) {
    if (adress != null) {
      adressesList.add(adress);
    }
  }

  @override
  String toString() {
    return """
\n-----------------
date - $dateOfBirth
adresses - $adressesList
phoneNumbersList - $phoneNumbersList
""";
  }
}
