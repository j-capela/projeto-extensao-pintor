import 'package:flutter/material.dart';

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

  void _salvarCliente() {
    if (_formKey.currentState!.validate()) {
      // Aqui você salvaria no banco de dados
      print("Cliente cadastrado: ${nomeController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cliente cadastrado com sucesso!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o nome";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: "Endereço"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarCliente,
                child: Text("Salvar Cliente"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
