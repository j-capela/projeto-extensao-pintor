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

  // --- REFATORAÇÃO: Camada de Validação ---
  List<String> validar() {
    List<String> erros = [];

    // O serviço precisa ter um título/nome claro
    if (nome.trim().isEmpty) {
      erros.add("O nome do serviço não pode ser vazio.");
    }

    // A descrição é essencial para saber o que o pintor vai fazer
    if (descricao.trim().isEmpty) {
      erros.add("A descrição do serviço é obrigatória.");
    }

    // O valor do serviço não pode ser negativo nem zero (ninguém trabalha de graça num app de gestão!)
    if (valor <= 0) {
      erros.add("O valor do serviço deve ser maior que zero.");
    }

    return erros;
  }
}