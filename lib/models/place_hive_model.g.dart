// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceHiveModelAdapter extends TypeAdapter<PlaceHiveModel> {
  @override
  final int typeId = 1;

  @override
  PlaceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceHiveModel(
      name: fields[0] as String,
      description: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      type: fields[4] as String,
      comments: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
