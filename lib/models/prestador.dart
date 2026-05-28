import 'package:hive/hive.dart';

part 'prestador.g.dart';

@HiveType(typeId: 0)
class Prestador {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String telefone;

  @HiveField(2)
  String email;

  @HiveField(3)
  String logotipoPath; // Caminho da imagem salva no dispositivo

  Prestador(
      {required this.nome,
      required this.telefone,
      required this.email,
      required this.logotipoPath});
}
