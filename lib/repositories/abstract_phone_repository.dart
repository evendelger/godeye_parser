import 'package:phone_corrector/domain/models/models.dart';

abstract class AbstractPhonesDataRepository {
  Future<PersonFileModel> getDataFromFile(String name);
  Future<List<String>> searchByRegion(PersonFileModel model, String region);
}
