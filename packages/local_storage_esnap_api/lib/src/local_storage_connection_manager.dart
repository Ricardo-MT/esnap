import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/local_storage_esnap_api.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';

/// Makes sure hive and its boxes initialize correctly
class LocalStorageConnectionManager {
  /// Basic constructor
  LocalStorageConnectionManager({
    required this.colorApi,
    required this.classificationApi,
    required this.classificationTypeApi,
    required this.occasionApi,
    required this.esnapApi,
    required this.outfitApi,
  });

  /// Collection of ColorApi services
  final LocalStorageColorApi colorApi;

  /// Collection of ClassificationApi services
  final LocalStorageClassificationApi classificationApi;

  /// Collection of ClassificationApi services
  final LocalStorageClassificationTypeApi classificationTypeApi;

  /// Collection of OccasionApi services
  final LocalStorageOccasionApi occasionApi;

  /// Collection of ClassificationApi services
  final LocalStorageEsnapApi esnapApi;

  /// Collection of OutfitApi services
  final LocalStorageOutfitApi outfitApi;

  /// Initializes all connections and returns an instance of a
  /// LocalStorageConnectionManager
  static Future<LocalStorageConnectionManager> initialize() async {
    await Hive.initFlutter();
    final migratedBox = await Hive.openBox<bool>(EsnapBoxes.migrated);
    final typesApi = await LocalStorageClassificationTypeApi.initializer();
    final [colorApi, classificationApi, occasionApi] = await Future.wait([
      LocalStorageColorApi.initializer(),
      LocalStorageClassificationApi.initializer(typesApi.box.values.toList()),
      LocalStorageOccasionApi.initializer()
    ]);
    final [esnapApi, outfitApi, _] = await Future.wait(
      [
        LocalStorageEsnapApi.initializer(),
        LocalStorageOutfitApi.initializer(),
        migratedBox.close()
      ],
    );
    return LocalStorageConnectionManager(
      colorApi: colorApi as LocalStorageColorApi,
      classificationTypeApi: typesApi,
      classificationApi: classificationApi as LocalStorageClassificationApi,
      occasionApi: occasionApi as LocalStorageOccasionApi,
      esnapApi: esnapApi as LocalStorageEsnapApi,
      outfitApi: outfitApi as LocalStorageOutfitApi,
    );
  }
}
