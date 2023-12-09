import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String getTranslatedNameFromOutfit(BuildContext context, Outfit outfit) {
  var res = '';
  final a = getTranslatedNameFromItem(context, outfit.top);
  final b = getTranslatedNameFromItem(context, outfit.bottom);
  final c = getTranslatedNameFromItem(context, outfit.shoes);

  res = [a, b, c].where((element) => element.isNotEmpty).join(', ');

  res = res.toLowerCase();
  return res.isEmpty ? '-' : '${res[0].toUpperCase()}${res.substring(1)}';
}

String getTranslatedNameFromItem(BuildContext context, Item? item) {
  final translateBloc = context.read<TranslationsBloc>();
  var name = '';
  if (translateBloc.state.languageCode == 'es') {
    name =
        translateBloc.getTranslationForClassification(item?.classification) ??
            '';
    if (item?.color != null) {
      name +=
          '${name.isEmpty ? '' : ' '}${translateBloc.getTranslationForColor(item?.color) ?? ''}';
    }
  } else {
    if (item?.color != null) {
      name = translateBloc.getTranslationForColor(item?.color) ?? '';
    }
    if (item?.classification != null) {
      name +=
          '${name.isEmpty ? '' : ' '}${translateBloc.getTranslationForClassification(item?.classification) ?? ''}';
    } else {
      name = '';
    }
  }
  return name;
}
