import 'package:flutter/material.dart';
import 'cadastro_cliente_screen.dart';
import 'cadastro_prestador_screen.dart';
import 'cadastro_servico_screen.dart';
import 'orcamento_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Pintor - Orçamentos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroClienteScreen()),
                );
              },
              child: Text("Cadastrar Cliente"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroPrestadorScreen()),
                );
              },
              child: Text("Cadastrar Prestador"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroServicoScreen()),
                );
              },
              child: Text("Cadastrar Serviço"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrcamentoScreen()),
                );
              },
              child: Text("Gerar Orçamento"),
            ),
          ],
        ),
      ),
    );
  }
}
