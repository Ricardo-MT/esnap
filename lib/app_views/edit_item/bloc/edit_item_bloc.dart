import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required EsnapRepository esnapRepository,
    required Item? initialItem,
  })  : _esnapRepository = esnapRepository,
        super(
          EditItemState(
            initialItem: initialItem,
            color: initialItem?.color,
            imagePath: initialItem?.imagePath,
            classification: initialItem?.classification,
            occasions: initialItem?.occasions.toList() ?? [],
            favorite: initialItem?.favorite ?? false,
          ),
        ) {
    on<EditItemImagePathChanged>(_onImageChanged);
    on<EditItemColorChanged>(_onColorChanged);
    on<EditItemClassificationChanged>(_onClassificationChanged);
    on<EditItemOccasionsChanged>(_onOccasionsChanged);
    on<EditItemSubmitted>(_onSubmitted);
    on<EditItemFavoriteChanged>(_onFavoriteChanged);
  }

  final EsnapRepository _esnapRepository;

  void _onImageChanged(
    EditItemImagePathChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  void _onColorChanged(
    EditItemColorChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _onClassificationChanged(
    EditItemClassificationChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(classification: event.classification));
  }

  void _onOccasionsChanged(
    EditItemOccasionsChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(occasions: event.occasions));
  }

  void _onFavoriteChanged(
    EditItemFavoriteChanged event,
    Emitter<EditItemState> emit,
  ) {
    emit(state.copyWith(favorite: event.favorite));
  }

  Future<void> _onSubmitted(
    EditItemSubmitted event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(status: EditItemStatus.loading));
    final item = (state.initialItem ?? Item()).copyWith(
      color: state.color,
      classification: state.classification,
      occasions: state.occasions,
      imagePath: state.imagePath,
      favorite: state.favorite,
    );
    try {
      await _esnapRepository.saveItem(item);
      emit(state.copyWith(status: EditItemStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: EditItemStatus.failure));
    }
  }
}
