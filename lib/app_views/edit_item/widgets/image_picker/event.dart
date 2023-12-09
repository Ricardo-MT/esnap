part of 'bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object?> get props => [];
}

final class ImagePickerSourceAsked extends ImagePickerEvent {
  const ImagePickerSourceAsked();
}

final class ImagePickerReset extends ImagePickerEvent {
  const ImagePickerReset();
}

final class ImagePickerSourceSelected extends ImagePickerEvent {
  const ImagePickerSourceSelected(this.source);

  final ImageSource source;

  @override
  List<Object?> get props => [source];
}
