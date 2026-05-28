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

  // --- REFATORAÇÃO: Camada de Validação ---
  // Esse método retorna uma lista de erros. Se a lista voltar vazia, o cliente é válido.
  List<String> validar() {
    List<String> erros = [];

    // Proteção contra nomes vazios ou só com espaços
    if (nome.trim().isEmpty) {
      erros.add("O nome do cliente não pode ser vazio.");
    }

    // Proteção básica para o telefone (ex: deve ter pelo menos 8 dígitos)
    if (telefone.trim().length < 8) {
      erros.add("Telefone inválido. Insira um número válido.");
    }

    // Endereço também não deveria ser completamente vazio para um app de prestador
    if (endereco.trim().isEmpty) {
      erros.add("O endereço é obrigatório para o atendimento.");
    }

    return erros;
  }
}