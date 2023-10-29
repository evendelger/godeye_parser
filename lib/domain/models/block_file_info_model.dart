class BlockFileInfoModel {
  BlockFileInfoModel({
    this.dateOfBirth,
    this.phone,
    this.adress,
  });

  DateTime? dateOfBirth;
  String? phone;
  String? adress;

  @override
  String toString() {
    return 'date - $dateOfBirth, phone - $phone, adress - $adress';
  }
}
