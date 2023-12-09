import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_api/esnap_api.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'translations_event.dart';
part 'translations_state.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  TranslationsBloc({
    required String languageCode,
    required ClassificationRepository classificationRepository,
    required ColorRepository colorRepository,
    required OccasionRepository occasionRepository,
  })  : _classificationRepository = classificationRepository,
        _colorRepository = colorRepository,
        _occasionRepository = occasionRepository,
        super(
          TranslationsState(
            languageCode: languageCode,
          ),
        ) {
    on<TranslationsLanguageChanged>(_onLanguageChanged);
  }

  final ClassificationRepository _classificationRepository;
  final ColorRepository _colorRepository;
  final OccasionRepository _occasionRepository;

  FutureOr<void> _onLanguageChanged(
    TranslationsLanguageChanged event,
    Emitter<TranslationsState> emit,
  ) {
    final classifications = <String, EsnapClassificationTranslation>{};
    _classificationRepository
        .getStaticTranslations()
        .where((t) => t.languageCode == event.languageCode)
        .forEach((element) {
      classifications[element.classificationId] = element;
    });
    final colors = <String, EsnapColorTranslation>{};
    _colorRepository
        .getStaticTranslations()
        .where((t) => t.languageCode == event.languageCode)
        .forEach((element) {
      colors[element.colorId] = element;
    });
    final occasions = <String, EsnapOccasionTranslation>{};
    _occasionRepository
        .getStaticTranslations()
        .where((t) => t.languageCode == event.languageCode)
        .forEach((element) {
      occasions[element.occasionId] = element;
    });
    emit(
      state.copyWith(
        classifications: classifications,
        colors: colors,
        occasions: occasions,
      ),
    );
  }

  String? getTranslationForClassification(EsnapClassification? classification) {
    if (classification == null) {
      return null;
    }
    final translation = state.classifications[classification.id];
    return translation?.name;
  }

  String? getTranslationForColor(EsnapColor? color) {
    if (color == null) {
      return null;
    }
    final translation = state.colors[color.id];
    return translation?.name;
  }

  String? getTranslationForOccasion(EsnapOccasion? occasion) {
    if (occasion == null) {
      return null;
    }
    final translation = state.occasions[occasion.id];
    return translation?.name;
  }
}
