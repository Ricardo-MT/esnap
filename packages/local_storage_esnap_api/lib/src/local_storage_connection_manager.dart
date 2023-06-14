import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/local_storage_esnap_api.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';

/// Makes sure hive and its boxes initialize correctly
class LocalStorageConnectionManager {
  /// Basic constructor
  LocalStorageConnectionManager({
    required this.colorApi,
    required this.classificationApi,
    required this.occasionApi,
    required this.esnapApi,
  });

  /// Collection of ColorApi services
  final LocalStorageColorApi colorApi;

  /// Collection of ClassificationApi services
  final LocalStorageClassificationApi classificationApi;

  /// Collection of OccasionApi services
  final LocalStorageOccasionApi occasionApi;

  /// Collection of ClassificationApi services
  final LocalStorageEsnapApi esnapApi;

  /// Initializes all connections and returns an instance of a
  /// LocalStorageConnectionManager
  static Future<LocalStorageConnectionManager> initialize() async {
    await Hive.initFlutter();
    final migratedBox = await Hive.openBox<bool>(EsnapBoxes.migrated);
    final [colorApi, classificationApi, occasionApi] = await Future.wait([
      LocalStorageColorApi.initializer(),
      LocalStorageClassificationApi.initializer(),
      LocalStorageOccasionApi.initializer()
    ]);
    final [esnapApi, _] = await Future.wait(
      [
        LocalStorageEsnapApi.initializer(),
        () async {
          await migratedBox.close();
          return 'null';
        }()
      ],
    );
    return LocalStorageConnectionManager(
      colorApi: colorApi as LocalStorageColorApi,
      classificationApi: classificationApi as LocalStorageClassificationApi,
      occasionApi: occasionApi as LocalStorageOccasionApi,
      esnapApi: esnapApi as LocalStorageEsnapApi,
    );
  }
}
