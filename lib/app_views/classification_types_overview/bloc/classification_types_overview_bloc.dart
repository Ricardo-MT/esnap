import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'classification_types_overview_event.dart';
part 'classification_types_overview_state.dart';

class ClassificationTypesOverviewBloc extends Bloc<
    ClassificationTypesOverviewEvent, ClassificationTypesOverviewState> {
  ClassificationTypesOverviewBloc({
    required ClassificationTypeRepository classificationTypeRepository,
  })  : _classificationTypeRepository = classificationTypeRepository,
        super(const ClassificationTypesOverviewState()) {
    on<ClassificationTypesOverviewSubscriptionRequested>(
      _onSubscriptionRequested,
    );
  }

  final ClassificationTypeRepository _classificationTypeRepository;

  Future<void> _onSubscriptionRequested(
    ClassificationTypesOverviewSubscriptionRequested event,
    Emitter<ClassificationTypesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        status: () => ClassificationTypesOverviewStatus.loading,
      ),
    );

    await emit.forEach<List<EsnapClassificationType>>(
      _classificationTypeRepository.getClassificationTypes(),
      onData: (classifications) => state.copyWith(
        status: () => ClassificationTypesOverviewStatus.success,
        types: () => classifications,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ClassificationTypesOverviewStatus.failure,
      ),
    );
  }
}
