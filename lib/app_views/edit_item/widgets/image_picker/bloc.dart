import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'event.dart';
part 'state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(const ImagePickerState()) {
    on<ImagePickerSourceAsked>(_onImagePickerSourceAsked);
    on<ImagePickerSourceSelected>(_onImagePickerSourceSelected);
    on<ImagePickerReset>(_onImagePickerReset);
  }

  FutureOr<void> _onImagePickerReset(
    ImagePickerReset event,
    Emitter<ImagePickerState> emit,
  ) {
    emit(const ImagePickerState());
  }

  FutureOr<void> _onImagePickerSourceAsked(
    ImagePickerSourceAsked event,
    Emitter<ImagePickerState> emit,
  ) {
    emit(const ImagePickerState(status: ImagePickerStatus.askingSource));
  }

  FutureOr<void> _onImagePickerSourceSelected(
    ImagePickerSourceSelected event,
    Emitter<ImagePickerState> emit,
  ) {
    emit(
      state.copyWith(
        status: ImagePickerStatus.initial,
        source: event.source,
      ),
    );
  }
}
