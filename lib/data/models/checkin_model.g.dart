// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckinModelAdapter extends TypeAdapter<CheckinModel> {
  @override
  final int typeId = 1;

  @override
  CheckinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckinModel(
      id: fields[0] as String,
      taskId: fields[1] as String,
      notes: fields[2] as String,
      category: fields[3] as String,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      createdAt: fields[6] as DateTime,
      syncStatus: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CheckinModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
