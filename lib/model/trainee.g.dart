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
      id: fields[0] as String,
      name: fields[1] as String,
      feePerSession: fields[2] as double,
      imageUrl: fields[3] as String?,
      sessionsLeft: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Trainee obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.feePerSession)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.sessionsLeft);
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
