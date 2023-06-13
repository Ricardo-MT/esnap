import 'package:esnap/app/app.dart';
import 'package:esnap/bootstrap.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_esnap_api/local_storage_esnap_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final esnapApi = LocalStorageEsnapApi();
  final esnapRepository = EsnapRepository(esnapApi: esnapApi);

  final colorApi = LocalStorageColorApi();
  final colorRepository = ColorRepository(colorApi: colorApi);
  bootstrap(
    () => App(
      esnapRepository: esnapRepository,
      colorRepository: colorRepository,
    ),
  );
}
