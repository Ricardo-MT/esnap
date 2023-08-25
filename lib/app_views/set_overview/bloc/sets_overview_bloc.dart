import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'sets_overview_event.dart';
part 'sets_overview_state.dart';

class SetsOverviewBloc extends Bloc<SetsOverviewEvent, SetsOverviewState> {
  SetsOverviewBloc({
    required OutfitRepository outfitRepository,
  })  : _outfitRepository = outfitRepository,
        super(const SetsOverviewState()) {
    on<SetsOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  final OutfitRepository _outfitRepository;

  Future<void> _onSubscriptionRequested(
    SetsOverviewSubscriptionRequested event,
    Emitter<SetsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => SetsOverviewStatus.loading));

    await emit.forEach<List<Outfit>>(
      _outfitRepository.getOutfits(),
      onData: (items) => state.copyWith(
        status: () => SetsOverviewStatus.success,
        items: () => items,
      ),
      onError: (_, __) => state.copyWith(
        status: () => SetsOverviewStatus.failure,
      ),
    );
  }
}
