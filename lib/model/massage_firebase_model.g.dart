// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'massage_firebase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 1;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as String,
      senderUid: fields[1] as String,
      receiverUid: fields[2] as String,
      contents: fields[3] as String,
      timestamp: fields[4] as DateTime,
      isRead: fields[5] as bool,
      senderNickname: fields[6] as String,
      receiverNickname: fields[7] as String,
      appUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderUid)
      ..writeByte(2)
      ..write(obj.receiverUid)
      ..writeByte(3)
      ..write(obj.contents)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.senderNickname)
      ..writeByte(7)
      ..write(obj.receiverNickname)
      ..writeByte(8)
      ..write(obj.appUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
