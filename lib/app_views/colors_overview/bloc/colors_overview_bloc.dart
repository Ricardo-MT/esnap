import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'colors_overview_event.dart';
part 'colors_overview_state.dart';

class ColorsOverviewBloc
    extends Bloc<ColorsOverviewEvent, ColorsOverviewState> {
  ColorsOverviewBloc({
    required ColorRepository colorRepository,
  })  : _colorRepository = colorRepository,
        super(const ColorsOverviewState()) {
    on<ColorsOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  final ColorRepository _colorRepository;

  Future<void> _onSubscriptionRequested(
    ColorsOverviewSubscriptionRequested event,
    Emitter<ColorsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => ColorsOverviewStatus.loading));

    await emit.forEach<List<EsnapColor>>(
      _colorRepository.getColors(),
      onData: (colors) => state.copyWith(
        status: () => ColorsOverviewStatus.success,
        colors: () => colors,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ColorsOverviewStatus.failure,
      ),
    );
  }
}
