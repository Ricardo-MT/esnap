import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_outfit_state.dart';
part 'edit_outfit_event.dart';

class EditOutfitBloc extends Bloc<EditOutfitEvent, EditOutfitState> {
  EditOutfitBloc({
    required OutfitRepository outfitRepository,
    required String classificationType,
    Outfit? outfit,
  })  : _outfitRepository = outfitRepository,
        super(
          EditOutfitState(
            initialOutfit: outfit,
            type: classificationType,
            top: outfit?.top,
            bottom: outfit?.bottom,
            shoes: outfit?.shoes,
          ),
        ) {
    on<EditOutfitTypeChanged>(_onTypeSelected);
    on<EditOutfitClassificationChanged>(_onClassificationSelected);
    on<EditOutfitItemSubmitted>(_onItemSubmitted);
    on<EditOutfitRemovedTop>((event, emit) {
      emit(state.copyWith(forceTop: true));
    });
    on<EditOutfitRemovedBottom>((event, emit) {
      emit(state.copyWith(forceBottom: true));
    });
    on<EditOutfitRemovedShoes>((event, emit) {
      emit(state.copyWith(forceShoes: true));
    });
    on<EditOutfitSubmitted>(_onOutfitSubmitted);
  }
  final OutfitRepository _outfitRepository;

  FutureOr<void> _onTypeSelected(
    EditOutfitTypeChanged event,
    Emitter<EditOutfitState> emit,
  ) {
    emit(
      state.copyWith(
        type: event.type,
        forceClassification: true,
      ),
    );
  }

  FutureOr<void> _onClassificationSelected(
    EditOutfitClassificationChanged event,
    Emitter<EditOutfitState> emit,
  ) {
    emit(
      state.copyWith(
        classification: event.classification,
        forceClassification: true,
      ),
    );
  }

  FutureOr<void> _onItemSubmitted(
    EditOutfitItemSubmitted event,
    Emitter<EditOutfitState> emit,
  ) {
    if (state.type == 'Top') {
      emit(
        state.copyWith(
          top: event.item,
          forceTop: true,
        ),
      );
    } else if (state.type == 'Bottom') {
      emit(
        state.copyWith(
          bottom: event.item,
          forceBottom: true,
        ),
      );
    } else if (state.type == 'Shoes') {
      emit(
        state.copyWith(
          shoes: event.item,
          forceShoes: true,
        ),
      );
    }
  }

  FutureOr<void> _onOutfitSubmitted(
    EditOutfitSubmitted event,
    Emitter<EditOutfitState> emit,
  ) async {
    emit(state.copyWith(status: EditOutfitStatus.loading));
    try {
      await _outfitRepository.saveOutfit(
        Outfit(
          id: state.initialOutfit?.id,
          top: state.top,
          bottom: state.bottom,
          shoes: state.shoes,
        ),
      );
      emit(state.copyWith(status: EditOutfitStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditOutfitStatus.failure));
    }
  }
}
