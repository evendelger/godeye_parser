abstract class StorageKeys {
  static const filesFolderKey = "filesPath";
  static const appSizeKey = "appSize";
}

enum StorageSizeValue {
  fullSize('full'),
  miniSize('mini');

  final String value;
  const StorageSizeValue(this.value);
}
