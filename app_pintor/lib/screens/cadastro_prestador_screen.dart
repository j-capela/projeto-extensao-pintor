import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/prestador.dart';

class CadastroPrestadorScreen extends StatefulWidget {
  const CadastroPrestadorScreen({super.key});

  @override
  _CadastroPrestadorScreenState createState() =>
      _CadastroPrestadorScreenState();
}

class _CadastroPrestadorScreenState extends State<CadastroPrestadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _logotipoPath;

  void _salvarPrestador() async {
    if (_formKey.currentState!.validate()) {
      final prestador = Prestador(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        logotipoPath: _logotipoPath ?? '',
      );

      var box = await Hive.openBox<Prestador>('prestadorBox');
      await box.put('prestador', prestador);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dados do prestador salvos com sucesso!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro do Prestador")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? "Informe o nome" : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Informe o telefone" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains("@")
                    ? "E-mail inválido"
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPrestador,
                child: Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
