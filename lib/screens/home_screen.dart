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
      appBar: AppBar(
        title: const Text(
          "Painel de Gestão - Pintor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os botões na tela
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícone central para dar uma cara mais amigável ao app
            const Icon(Icons.format_paint, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 40), // Espaçamento
            
            // Utilizando o nosso Componente Personalizado
            _MenuButton(
              icon: Icons.person_add,
              label: "Cadastrar Cliente",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroClienteScreen()),
              ),
            ),
            const SizedBox(height: 16),
            
            _MenuButton(
              icon: Icons.engineering,
              label: "Cadastrar Prestador",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroPrestadorScreen()),
              ),
            ),
            const SizedBox(height: 16),
            
            _MenuButton(
              icon: Icons.design_services,
              label: "Cadastrar Serviço",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroServicoScreen()),
              ),
            ),
            const SizedBox(height: 16),
            
            _MenuButton(
              icon: Icons.request_quote,
              label: "Gerar Orçamento",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrcamentoScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- COMPONENTIZAÇÃO: Criando um Widget Reutilizável ---
// O underline (_) antes do nome indica que esta classe é privada, 
// usada apenas dentro deste arquivo.
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
    );
  }
}