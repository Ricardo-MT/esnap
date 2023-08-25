// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassificationSchemaAdapter extends TypeAdapter<ClassificationSchema> {
  @override
  final int typeId = 3;

  @override
  ClassificationSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassificationSchema(
      id: fields[0] as String,
      name: fields[1] as String,
      classificationType: (fields[2] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, ClassificationSchema obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classificationType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassificationSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
