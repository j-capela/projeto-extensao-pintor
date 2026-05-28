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

  Prestador({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.logotipoPath,
  });

  // --- REFATORAÇÃO: Camada de Validação ---
  List<String> validar() {
    List<String> erros = [];

    // Validando o Nome (Não pode ser vazio e NÃO PODE ter números)
    if (nome.trim().isEmpty) {
      erros.add("O nome do prestador é obrigatório.");
    } else if (RegExp(r'[0-9]').hasMatch(nome)) {
      erros.add("O nome não pode conter números.");
    }

    if (telefone.trim().length < 8) {
      erros.add("Informe um telefone válido com pelo menos 8 dígitos.");
    }

    // O E-mail agora é opcional, mas se for preenchido, tem que ser válido
    if (email.trim().isNotEmpty) {
      if (!email.contains("@") || !email.contains(".")) {
        erros.add("Informe um e-mail válido.");
      }
    }

    return erros;
  }
}