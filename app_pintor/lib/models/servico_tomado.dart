import 'package:hive/hive.dart';

part 'servico_tomado.g.dart';

@HiveType(typeId: 2)
class ServicoTomado extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String descricao;

  @HiveField(2)
  double valor;

  ServicoTomado({
    required this.nome,
    required this.descricao,
    required this.valor,
  });
}
