import 'dart:developer';
import 'dart:io';

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
            color: initialItem?.color ?? '',
            classification: initialItem?.classification ?? '',
            occasions: initialItem?.occasions ?? [],
          ),
        ) {
    on<EditItemColorChanged>(_onColorChanged);
    on<EditItemClassificationChanged>(_onClassificationChanged);
    on<EditItemOccasionsChanged>(_onOccasionsChanged);
    on<EditItemSubmitted>(_onSubmitted);
  }

  final EsnapRepository _esnapRepository;

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

  Future<void> _onSubmitted(
    EditItemSubmitted event,
    Emitter<EditItemState> emit,
  ) async {
    emit(state.copyWith(status: EditItemStatus.loading));
    final item = (state.initialItem ??
            Item(
              color: '',
              classification: '',
              image: File(''),
            ))
        .copyWith(
      color: state.color,
      classification: state.classification,
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
