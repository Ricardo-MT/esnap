import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'detail_outfit_event.dart';
part 'detail_outfit_state.dart';

class DetailOutfitBloc extends Bloc<DetailOutfitEvent, DetailOutfitState> {
  DetailOutfitBloc({
    required OutfitRepository outfitRepository,
    required Outfit item,
  })  : _outfitRepository = outfitRepository,
        super(
          DetailOutfitState(
            item: item,
          ),
        ) {
    on<DetailOutfitDeleteSubmitted>(_onDeleteSubmitted);
  }

  final OutfitRepository _outfitRepository;

  Future<void> _onDeleteSubmitted(
    DetailOutfitDeleteSubmitted event,
    Emitter<DetailOutfitState> emit,
  ) async {
    emit(state.copyWith(status: DetailOutfitStatus.loading));
    final item = state.item;
    try {
      await _outfitRepository.deleteOutfit(item.id);
      emit(state.copyWith(status: DetailOutfitStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: DetailOutfitStatus.failure));
    }
  }
}
