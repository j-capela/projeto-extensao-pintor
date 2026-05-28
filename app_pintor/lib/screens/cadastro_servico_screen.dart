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
    if (_formKey.currentState!.validate()) {
      final servico = ServicoTomado(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text),
      );

      var box = await Hive.openBox<ServicoTomado>('servicoBox');
      await box.add(servico);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Serviço cadastrado com sucesso!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Serviço")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome do Serviço"),
                validator: (value) =>
                    value!.isEmpty ? "Informe o nome do serviço" : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: "Descrição"),
                maxLines: 2,
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: "Valor"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Informe o valor" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarServico,
                child: Text("Salvar Serviço"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
