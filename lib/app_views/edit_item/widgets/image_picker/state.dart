part of 'bloc.dart';

enum ImagePickerStatus { initial, askingSource }

final class ImagePickerState extends Equatable {
  const ImagePickerState({
    this.status = ImagePickerStatus.initial,
    this.source,
  });

  final ImagePickerStatus status;
  final ImageSource? source;

  ImagePickerState copyWith({
    ImagePickerStatus? status,
    ImageSource? source,
    bool forceSource = false,
  }) {
    return ImagePickerState(
      status: status ?? this.status,
      source: forceSource ? source : (source ?? this.source),
    );
  }

  @override
  List<Object?> get props => [
        status,
        source,
      ];
}
