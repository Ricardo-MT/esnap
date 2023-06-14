import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'occasions_overview_event.dart';
part 'occasions_overview_state.dart';

class OccasionsOverviewBloc
    extends Bloc<OccasionsOverviewEvent, OccasionsOverviewState> {
  OccasionsOverviewBloc({
    required OccasionRepository occasionRepository,
  })  : _occasionRepository = occasionRepository,
        super(const OccasionsOverviewState()) {
    on<OccasionsOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  final OccasionRepository _occasionRepository;

  Future<void> _onSubscriptionRequested(
    OccasionsOverviewSubscriptionRequested event,
    Emitter<OccasionsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => OccasionsOverviewStatus.loading));

    await emit.forEach<List<EsnapOccasion>>(
      _occasionRepository.getOccasions(),
      onData: (occasions) => state.copyWith(
        status: () => OccasionsOverviewStatus.success,
        occasions: () => occasions,
      ),
      onError: (_, __) => state.copyWith(
        status: () => OccasionsOverviewStatus.failure,
      ),
    );
  }
}
