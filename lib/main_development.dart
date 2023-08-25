import 'package:esnap/app/app.dart';
import 'package:esnap/bootstrap.dart';
import 'package:esnap/firebase_options_dev.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_esnap_api/local_storage_esnap_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connectionManager = await LocalStorageConnectionManager.initialize();

  final colorRepository = ColorRepository(colorApi: connectionManager.colorApi);

  final classificationRepository = ClassificationRepository(
    classificationApi: connectionManager.classificationApi,
  );

  final classificationTypeRepository = ClassificationTypeRepository(
    classificationTypeApi: connectionManager.classificationTypeApi,
  );

  final occasionRepository =
      OccasionRepository(occasionApi: connectionManager.occasionApi);

  final esnapRepository = EsnapRepository(esnapApi: connectionManager.esnapApi);

  final outfitRepository =
      OutfitRepository(outfitApi: connectionManager.outfitApi);

  // Firebase configuration for dev flavor
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await bootstrap(
    () => App(
      outfitRepository: outfitRepository,
      esnapRepository: esnapRepository,
      colorRepository: colorRepository,
      classificationRepository: classificationRepository,
      occasionRepository: occasionRepository,
      classificationTypeRepository: classificationTypeRepository,
    ),
  );
}
