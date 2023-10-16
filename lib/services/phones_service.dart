import 'package:godeye_parser/domain/data/data.dart';

class PhonesService {
  const PhonesService({required this.dataProvider});

  final DataProvider dataProvider;

  bool checkRegion(String phone, String trueRegion) {
    final firstCode = phone.substring(1, 4);
    final secondCode = int.parse(phone.substring(4));

    final listOfData = dataProvider.dataPhonesMap[firstCode];
    if (listOfData != null) {
      final correctList = listOfData.firstWhere(
        (listOfInfo) {
          final numStart = int.parse(listOfInfo[0]);
          final numEnd = int.parse(listOfInfo[1]);

          if (secondCode >= numStart && secondCode <= numEnd) {
            return true;
          }
          return false;
        },
        orElse: () => [],
      );
      if (correctList.isNotEmpty) {
        final region = correctList[2];
        if (region.toLowerCase().contains(trueRegion)) {
          return true;
        }
      }
    }
    return false;
  }
}
