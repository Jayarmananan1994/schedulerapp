// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TraineeAdapter extends TypeAdapter<Trainee> {
  @override
  final int typeId = 2;

  @override
  Trainee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trainee(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Trainee obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TraineeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
