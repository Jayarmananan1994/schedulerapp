// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainerAdapter extends TypeAdapter<Trainer> {
  @override
  final int typeId = 1;

  @override
  Trainer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trainer(
      fields[0] as String,
      fields[1] as String,
      fields[2] as double,
      fields[3] as String?,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Trainer obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.payRate)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
