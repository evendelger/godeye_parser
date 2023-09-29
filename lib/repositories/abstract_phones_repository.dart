import 'package:phone_corrector/domain/models/models.dart';

abstract class AbstractPhonesDataRepository {
  Future<PersonFileModel> getDataFromFile(
    String name,
  );
  Future<List<String>> searchByRegion(
    PersonFileModel model,
    String region,
  );
  (List<String>, List<String>) searchByCity(
    PersonFileModel model,
    String city,
  );
  (MapList, MapList) searchByExperience(
    PersonFileModel model,
    String experience,
  );
  Future<(List<String>, List<String>)> searchByText(
    String text,
    String region,
  );
}
