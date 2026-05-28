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
  List<String> validar() {
    List<String> erros = [];

    // Proteção contra nomes vazios e NÚMEROS no nome
    if (nome.trim().isEmpty) {
      erros.add("O nome do cliente não pode ser vazio.");
    } else if (RegExp(r'[0-9]').hasMatch(nome)) {
      erros.add("O nome do cliente não pode conter números.");
    }

    // Proteção básica para o telefone
    if (telefone.trim().length < 8) {
      erros.add("Telefone inválido. Insira um número válido.");
    }

    // Como o endereço é opcional, nós removemos a regra de erro dele!
    
    return erros;
  }
}