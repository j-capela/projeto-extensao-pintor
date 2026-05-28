import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 1)
class Cliente {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String telefone;

  @HiveField(2)
  String endereco;

  Cliente({required this.nome, required this.telefone, required this.endereco});
}
