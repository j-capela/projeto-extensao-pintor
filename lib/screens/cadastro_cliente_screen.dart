import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cliente.dart';

class CadastroClienteScreen extends StatefulWidget {
  const CadastroClienteScreen({super.key});

  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();

  void _salvarCliente() async {
    // 1. Validação visual
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Monta o objeto (o endereço pode ir em branco sem problemas)
    final cliente = Cliente(
      nome: nomeController.text,
      telefone: telefoneController.text,
      endereco: enderecoController.text, 
    );

    // 3. Validação da Regra de Negócio
    List<String> erros = cliente.validar();

    if (erros.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erros.first),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 4. Salvar no banco de dados DE VERDADE
    try {
      var box = await Hive.openBox<Cliente>('clienteBox');
      await box.add(cliente);

      // 5. Sucesso! Mostra a mensagem e volta pra Home
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente cadastrado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
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
      appBar: AppBar(title: const Text("Cadastro de Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value!.trim().isEmpty) return "Informe o nome";
                  if (RegExp(r'[0-9]').hasMatch(value)) return "O nome não pode conter números";
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.trim().isEmpty ? "Informe o telefone" : null,
              ),
              TextFormField(
                controller: enderecoController,
                decoration: const InputDecoration(labelText: "Endereço (Opcional)"),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _salvarCliente,
                icon: const Icon(Icons.person_add),
                label: const Text("Salvar Cliente", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}