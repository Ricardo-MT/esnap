import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'detail_item_event.dart';
part 'detail_item_state.dart';

class DetailItemBloc extends Bloc<DetailItemEvent, DetailItemState> {
  DetailItemBloc({
    required EsnapRepository esnapRepository,
    required Item item,
  })  : _esnapRepository = esnapRepository,
        super(
          DetailItemState(
            item: item,
          ),
        ) {
    on<DetailItemFavoriteChanged>(_onFavoriteChanged);
  }

  final EsnapRepository _esnapRepository;

  Future<void> _onFavoriteChanged(
    DetailItemFavoriteChanged event,
    Emitter<DetailItemState> emit,
  ) async {
    emit(state.copyWith(status: DetailItemStatus.loading));
    final item = state.item.copyWith(favorite: event.favorite);
    try {
      await _esnapRepository.saveItem(item);
      emit(state.copyWith(status: DetailItemStatus.initial, item: item));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: DetailItemStatus.failure));
    }
  }
}
