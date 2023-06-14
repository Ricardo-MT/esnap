import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'classifications_overview_event.dart';
part 'classifications_overview_state.dart';

class ClassificationsOverviewBloc
    extends Bloc<ClassificationsOverviewEvent, ClassificationsOverviewState> {
  ClassificationsOverviewBloc({
    required ClassificationRepository classificationRepository,
  })  : _classificationRepository = classificationRepository,
        super(const ClassificationsOverviewState()) {
    on<ClassificationsOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  final ClassificationRepository _classificationRepository;

  Future<void> _onSubscriptionRequested(
    ClassificationsOverviewSubscriptionRequested event,
    Emitter<ClassificationsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => ClassificationsOverviewStatus.loading));

    await emit.forEach<List<EsnapClassification>>(
      _classificationRepository.getClassifications(),
      onData: (classifications) => state.copyWith(
        status: () => ClassificationsOverviewStatus.success,
        classifications: () => classifications,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ClassificationsOverviewStatus.failure,
      ),
    );
  }
}
