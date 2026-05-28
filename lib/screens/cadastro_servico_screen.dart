import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/servico_tomado.dart';

class CadastroServicoScreen extends StatefulWidget {
  const CadastroServicoScreen({super.key});

  @override
  _CadastroServicoScreenState createState() => _CadastroServicoScreenState();
}

class _CadastroServicoScreenState extends State<CadastroServicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _salvarServico() async {
    // 1. Validação visual básica
    if (!_formKey.currentState!.validate()) {
      return; // Se já tem erro no formulário, não faz nada
    }

    // 2. Proteção contra o "vilão da vírgula"
    // Trocamos vírgula por ponto para não quebrar o double
    String valorDigitado = _valorController.text.replaceAll(',', '.');
    double valorFormatado = double.tryParse(valorDigitado) ?? 0.0;

    // 3. Montamos o objeto com o que o usuário digitou
    final servico = ServicoTomado(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      valor: valorFormatado,
    );

    // 4. A Mágica: Usamos a validação de domínio testada!
    List<String> erros = servico.validar();

    if (erros.isNotEmpty) {
      // Se a regra de negócio reclamar, mostramos o erro em uma barra VERMELHA
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erros.first), // Mostra o primeiro erro encontrado
          backgroundColor: Colors.red,
        ),
      );
      return; // Interrompe a função aqui para não salvar lixo no banco
    }

    // 5. Se os dados são perfeitos, salvamos no banco
    try {
      var box = await Hive.openBox<ServicoTomado>('servicoBox');
      await box.add(servico);

      // 6. Mostra sucesso (VERDE) e volta para a tela inicial
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Serviço cadastrado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Proteção extra caso o banco de dados falhe
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao acessar banco de dados: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Serviço")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do Serviço"),
                // A validação agora também ocorre aqui na tela
                validator: (value) =>
                    value!.isEmpty ? "Informe o nome do serviço" : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
                maxLines: 2,
                // Adicionamos o validador visual aqui!
                validator: (value) => value!.trim().isEmpty ? "Informe a descrição do serviço" : null,
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: "Valor (R\$)",
                  hintText: "Ex: 150.50",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? "Informe o valor" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _salvarServico,
                icon: const Icon(Icons.save),
                label: const Text("Salvar Serviço", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}