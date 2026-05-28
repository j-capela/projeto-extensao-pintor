import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import '../utils/pdf_generator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Certifique-se de que os caminhos dos imports batem com as suas pastas
import '../models/servico_tomado.dart';
import '../models/cliente.dart';
import '../models/prestador.dart';

class OrcamentoScreen extends StatefulWidget {
  const OrcamentoScreen({super.key});

  @override
  _OrcamentoScreenState createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  bool _isLoading = true;
  
  // Listas de dados
  List<ServicoTomado> servicos = [];
  List<bool> selecionados = [];
  List<Cliente> clientes = [];
  
  // Seleções do usuário
  Cliente? clienteSelecionado;
  Prestador? prestador;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    try {
      // 1. Abrindo as 3 caixas do banco de dados
      // ATENÇÃO: Verifique se os nomes das caixas batem exatamente com as telas de cadastro!
      var boxServicos = await Hive.openBox<ServicoTomado>('servicoBox');
      var boxClientes = await Hive.openBox<Cliente>('clienteBox');
      var boxPrestador = await Hive.openBox<Prestador>('prestadorBox');
      
      setState(() {
        servicos = boxServicos.values.toList();
        selecionados = List.generate(servicos.length, (index) => false);
        clientes = boxClientes.values.toList();
        
        // Puxa o perfil do prestador (se houver algum cadastrado)
        if (boxPrestador.isNotEmpty) {
          prestador = boxPrestador.get('prestador') ?? boxPrestador.values.first;
        }
        
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao abrir banco: $e");
      setState(() { _isLoading = false; });
    }
  }

Future<void> _gerarPdf() async {
    // Validações de Regras de Negócio
    if (prestador == null) {
      _mostrarErro("Cadastre o perfil do Prestador antes de gerar um orçamento.");
      return;
    }
    if (clienteSelecionado == null) {
      _mostrarErro("Selecione um Cliente para o orçamento.");
      return;
    }
    if (!selecionados.contains(true)) {
      _mostrarErro("Selecione pelo menos um serviço.");
      return;
    }

    // Filtra apenas os serviços que o usuário marcou no Checkbox
    List<ServicoTomado> servicosEscolhidos = [];
    for (int i = 0; i < servicos.length; i++) {
      if (selecionados[i]) {
        servicosEscolhidos.add(servicos[i]);
      }
    }

    // Chama o nosso utilitário para desenhar o PDF
    final pdf = await PdfGenerator.gerarDocumento(
      cliente: clienteSelecionado!,
      prestador: prestador!,
      servicos: servicosEscolhidos,
    );

    // Abre a visualização universal com o botão nativo de compartilhamento
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Orcamento_${clienteSelecionado!.nome.replaceAll(" ", "_")}.pdf',
    );
  }
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerar Orçamento")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown para selecionar o Cliente
                  const Text("Selecione o Cliente:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  clientes.isEmpty
                      ? const Text("Nenhum cliente cadastrado. Cadastre um cliente primeiro.", style: TextStyle(color: Colors.red))
                      : DropdownButtonFormField<Cliente>(
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          hint: const Text("Escolha um cliente"),
                          value: clienteSelecionado,
                          items: clientes.map((Cliente cliente) {
                            return DropdownMenuItem<Cliente>(
                              value: cliente,
                              child: Text(cliente.nome),
                            );
                          }).toList(),
                          onChanged: (Cliente? novoCliente) {
                            setState(() {
                              clienteSelecionado = novoCliente;
                            });
                          },
                        ),
                  
                  const SizedBox(height: 24),
                  const Text("Selecione os Serviços:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  
                  // Lista de serviços
                  Expanded(
                    child: servicos.isEmpty
                        ? const Center(child: Text("Nenhum serviço cadastrado."))
                        : ListView.builder(
                            itemCount: servicos.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: CheckboxListTile(
                                  title: Text(servicos[index].nome),
                                  subtitle: Text("R\$ ${servicos[index].valor.toStringAsFixed(2)}"),
                                  value: selecionados[index],
                                  activeColor: Colors.blueAccent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selecionados[index] = value!;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _gerarPdf,
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Gerar PDF"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}