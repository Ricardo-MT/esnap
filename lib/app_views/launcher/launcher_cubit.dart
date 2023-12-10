import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:esnap/utils/app_values.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherCubit extends Cubit<void> {
  LauncherCubit() : super(null);

  Future<void> launchAppStore() async {
    if (!await launchUrl(
      Uri.parse(AppValues.appStoreUrl[Platform.operatingSystem]!),
    )) {
      throw Exception(
        'Error ${AppValues.appStoreUrl[Platform.operatingSystem]}',
      );
    }
  }

  Future<void> launchPrivacyPolicy() async {
    if (!await launchUrl(Uri.parse(AppValues.privacyUrl))) {
      throw Exception('Error ${AppValues.privacyUrl}');
    }
  }
}
