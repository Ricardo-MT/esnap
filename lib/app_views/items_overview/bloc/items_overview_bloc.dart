import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap/app_views/items_overview/models/items_view_filter.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'items_overview_event.dart';
part 'items_overview_state.dart';

class ItemsOverviewBloc extends Bloc<ItemsOverviewEvent, ItemsOverviewState> {
  ItemsOverviewBloc({
    required EsnapRepository esnapRepository,
  })  : _esnapRepository = esnapRepository,
        super(const ItemsOverviewState()) {
    on<ItemsOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<ItemsOverviewFilterChanged>(_onFilterChanged);
  }

  final EsnapRepository _esnapRepository;

  Future<void> _onSubscriptionRequested(
    ItemsOverviewSubscriptionRequested event,
    Emitter<ItemsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => ItemsOverviewStatus.loading));

    await emit.forEach<List<Item>>(
      _esnapRepository.getItems(),
      onData: (items) => state.copyWith(
        status: () => ItemsOverviewStatus.success,
        items: () => items,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ItemsOverviewStatus.failure,
      ),
    );
  }

  void _onFilterChanged(
    ItemsOverviewFilterChanged event,
    Emitter<ItemsOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }
}
