import 'package:phone_corrector/domain/models/models.dart';

enum TypeOfSearch {
  region,
  city,
  experience,
}

abstract class AbstractPhonesDataRepository {
  Future<PersonFileModel> getDataFromFile(String name);
}
