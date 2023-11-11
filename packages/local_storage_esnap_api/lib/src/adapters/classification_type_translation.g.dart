// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_type_translation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassificationTypeTranslationSchemaAdapter
    extends TypeAdapter<ClassificationTypeTranslationSchema> {
  @override
  final int typeId = 8;

  @override
  ClassificationTypeTranslationSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassificationTypeTranslationSchema(
      id: fields[0] as String,
      name: fields[1] as String,
      classificationTypeId: fields[2] as String,
      languageCode: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassificationTypeTranslationSchema obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classificationTypeId)
      ..writeByte(3)
      ..write(obj.languageCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassificationTypeTranslationSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
