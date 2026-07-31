// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketModelAdapter extends TypeAdapter<TicketModel> {
  @override
  final int typeId = 0;

  @override
  TicketModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketModel(
      id: fields[0] as String,
      subject: fields[1] as String,
      description: fields[2] as String,
      priorityIndex: fields[3] as int,
      categoryIndex: fields[4] as int,
      statusIndex: fields[5] as int,
      createdAtIso: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TicketModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priorityIndex)
      ..writeByte(4)
      ..write(obj.categoryIndex)
      ..writeByte(5)
      ..write(obj.statusIndex)
      ..writeByte(6)
      ..write(obj.createdAtIso);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
