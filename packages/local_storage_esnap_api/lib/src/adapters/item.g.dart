// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemSchemaAdapter extends TypeAdapter<ItemSchema> {
  @override
  final int typeId = 1;

  @override
  ItemSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemSchema()
      ..id = fields[0] as String
      ..color = fields[2] as String
      ..classification = fields[1] as String
      ..occasions = (fields[3] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, ItemSchema obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.classification)
      ..writeByte(3)
      ..write(obj.occasions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
