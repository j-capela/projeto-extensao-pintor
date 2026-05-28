// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestador.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrestadorAdapter extends TypeAdapter<Prestador> {
  @override
  final int typeId = 0;

  @override
  Prestador read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prestador(
      nome: fields[0] as String,
      telefone: fields[1] as String,
      email: fields[2] as String,
      logotipoPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prestador obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.telefone)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.logotipoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrestadorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
