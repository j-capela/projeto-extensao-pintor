import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/prestador.dart';

class CadastroPrestadorScreen extends StatefulWidget {
  const CadastroPrestadorScreen({super.key});

  @override
  _CadastroPrestadorScreenState createState() => _CadastroPrestadorScreenState();
}

class _CadastroPrestadorScreenState extends State<CadastroPrestadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _logotipoPath;

  void _salvarPrestador() async {
    // 1. Validação visual do formulário
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    // 2. Monta o objeto Prestador
    final prestador = Prestador(
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      logotipoPath: _logotipoPath ?? '',
    );

    // 3. Validação de Regra de Negócio (A nossa defesa)
    List<String> erros = prestador.validar();

    if (erros.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erros.first),
          backgroundColor: Colors.red,
        ),
      );
      return; // Trava o processo aqui se os dados não prestarem
    }

    // 4. Salvar no banco de dados com segurança
    try {
      var box = await Hive.openBox<Prestador>('prestadorBox');
      // Atualiza os dados do dono do app (sobrescreve o antigo)
      await box.put('prestador', prestador);

      // 5. Sucesso! Mostra a mensagem e volta pra Home
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dados do prestador atualizados com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao acessar o banco de dados: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil do Prestador")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome da Empresa ou Profissional"),
                validator: (value) {
                  if (value!.trim().isEmpty) return "Informe o nome";
                  // RegEx checando visualmente se há números
                  if (RegExp(r'[0-9]').hasMatch(value)) return "O nome não pode conter números";
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: "Telefone de Contato"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.trim().isEmpty ? "Informe o telefone" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-mail (Opcional)"),
                keyboardType: TextInputType.emailAddress,
                // E-mail só fica vermelho se o usuário digitar algo errado, se deixar em branco ele aceita
                validator: (value) {
                  if (value!.trim().isNotEmpty && !value.contains("@")) {
                    return "E-mail inválido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _salvarPrestador,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Salvar Prestador", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}