import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_tools_repository/image_tools_repository.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({
    required EsnapRepository esnapRepository,
    required ImageToolsRepository imageToolsRepository,
    required Item? initialItem,
  })  : _esnapRepository = esnapRepository,
        _imageToolsRepository = imageToolsRepository,
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
    on<EditItemRequestToggleImage>(_onToggleImageRequested);
    on<EditItemColorChanged>(_onColorChanged);
    on<EditItemClassificationChanged>(_onClassificationChanged);
    on<EditItemOccasionsChanged>(_onOccasionsChanged);
    on<EditItemSubmitted>(_onSubmitted);
    on<EditItemFavoriteChanged>(_onFavoriteChanged);
  }

  final EsnapRepository _esnapRepository;
  final ImageToolsRepository _imageToolsRepository;

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
      wasBackgroundRemoved: !state.isUsingOriginalImage,
    );
    try {
      // We need to evict the image from the cache if the background was removed
      // and the original image was not removed originally.
      if (!(state.initialItem?.wasBackgroundRemoved ?? true) &&
          !state.isUsingOriginalImage &&
          state.imagePath != null) {
        imageCache.evict(FileImage(File(state.imagePath!)));
      }
      await _esnapRepository.saveItem(
        item,
        !item.wasBackgroundRemoved
            ? File(state.imagePath!).readAsBytesSync()
            : state.backgroundRemovedImage!,
      );
      emit(state.copyWith(status: EditItemStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: EditItemStatus.failure));
    }
  }

  FutureOr<void> _onToggleImageRequested(
    EditItemRequestToggleImage event,
    Emitter<EditItemState> emit,
  ) async {
    if (state.imagePath == null) {
      return;
    }
    if (!state.isUsingOriginalImage) {
      emit(state.copyWith(isUsingOriginalImage: true));
      return;
    }
    if (state.backgroundRemovedImage != null) {
      emit(state.copyWith(isUsingOriginalImage: false));
      return;
    }
    emit(state.copyWith(removingBackgroundStatus: EditItemStatus.loading));
    try {
      final image = await _imageToolsRepository.removeBackground(
        File(state.imagePath!).readAsBytesSync(),
      );
      emit(
        state.copyWith(
          removingBackgroundStatus: EditItemStatus.success,
          backgroundRemovedImage: image,
          isUsingOriginalImage: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(removingBackgroundStatus: EditItemStatus.failure));
    }
  }
}
