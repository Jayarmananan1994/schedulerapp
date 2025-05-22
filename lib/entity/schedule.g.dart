// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 0;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule(
      id: fields[0] as String,
      title: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      trainee: fields[4] as Trainee,
      trainer: fields[5] as Staff,
      meetingnote: fields[6] as String,
      location: fields[7] as String?,
      traineeFee: fields[8] as double,
      trainerCost: fields[9] as double,
      packageId: fields[12] as String,
    )
      ..isCancelled = fields[10] as bool
      ..isForfeited = fields[11] as bool;
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.trainee)
      ..writeByte(5)
      ..write(obj.trainer)
      ..writeByte(6)
      ..write(obj.meetingnote)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.traineeFee)
      ..writeByte(9)
      ..write(obj.trainerCost)
      ..writeByte(10)
      ..write(obj.isCancelled)
      ..writeByte(11)
      ..write(obj.isForfeited)
      ..writeByte(12)
      ..write(obj.packageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
