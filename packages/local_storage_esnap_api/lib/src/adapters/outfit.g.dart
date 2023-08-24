// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutfitSchemaAdapter extends TypeAdapter<OutfitSchema> {
  @override
  final int typeId = 6;

  @override
  OutfitSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutfitSchema(
      id: fields[0] as String,
      top: (fields[1] as HiveList).castHiveList(),
      bottom: (fields[2] as HiveList).castHiveList(),
      shoes: (fields[3] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, OutfitSchema obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.top)
      ..writeByte(2)
      ..write(obj.bottom)
      ..writeByte(3)
      ..write(obj.shoes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
