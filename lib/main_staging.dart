import 'package:esnap/app/app.dart';
import 'package:esnap/bootstrap.dart';
import 'package:esnap/firebase_options_stg.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_esnap_api/local_storage_esnap_api.dart';
import 'package:preferences_api_services/preferences_api_services.dart';
import 'package:preferences_repository/preferences_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase configuration for dev flavor
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  final preferencesRepository = PreferencesRepository(
    client: await PreferencesApiServices.initializer(),
  );

  await bootstrap(
    () => App(
      preferencesRepository: preferencesRepository,
      outfitRepository: outfitRepository,
      esnapRepository: esnapRepository,
      colorRepository: colorRepository,
      classificationRepository: classificationRepository,
      occasionRepository: occasionRepository,
      classificationTypeRepository: classificationTypeRepository,
    ),
  );
}
