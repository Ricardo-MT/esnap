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
    return ItemSchema(
      id: fields[0] as String,
      classification: (fields[2] as HiveList).castHiveList(),
      occasions: (fields[3] as HiveList).castHiveList(),
      color: (fields[1] as HiveList).castHiveList(),
      imagePath: fields[4] as String,
      favorite: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ItemSchema obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.classification)
      ..writeByte(3)
      ..write(obj.occasions)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.favorite);
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
