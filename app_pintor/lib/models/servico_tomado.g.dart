// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servico_tomado.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServicoTomadoAdapter extends TypeAdapter<ServicoTomado> {
  @override
  final int typeId = 2;

  @override
  ServicoTomado read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServicoTomado(
      nome: fields[0] as String,
      descricao: fields[1] as String,
      valor: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ServicoTomado obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.descricao)
      ..writeByte(2)
      ..write(obj.valor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicoTomadoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
