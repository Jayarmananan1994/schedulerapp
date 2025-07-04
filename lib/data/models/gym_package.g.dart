// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_package.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GymPackageAdapter extends TypeAdapter<GymPackage> {
  @override
  final int typeId = 3;

  @override
  GymPackage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GymPackage(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as double,
      fields[4] as int,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GymPackage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.noOfSessions)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.noOfSessionsAvailable)
      ..writeByte(5)
      ..write(obj.traineeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GymPackageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
