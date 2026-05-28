import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import '../models/servico_tomado.dart';

class OrcamentoScreen extends StatefulWidget {
  const OrcamentoScreen({super.key});

  @override
  _OrcamentoScreenState createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  List<ServicoTomado> servicos = [];
  List<bool> selecionados = [];

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  void _carregarServicos() async {
    var box = await Hive.openBox<ServicoTomado>('servicoTomadoBox');
    setState(() {
      servicos = box.values.toList();
      selecionados = List.generate(servicos.length, (index) => false);
    });
  }

  Future<void> _gerarPdf() async {
    final pdf = pw.Document();
    double total = 0;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Orçamento de Serviços",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...List.generate(servicos.length, (index) {
                if (selecionados[index]) {
                  total += servicos[index].valor;
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          "• ${servicos[index].nome}: R\$ ${servicos[index].valor.toStringAsFixed(2)}"),
                      pw.SizedBox(height: 5),
                    ],
                  );
                }
                return pw.SizedBox();
              }),
              pw.Divider(),
              pw.Text("Total: R\$ ${total.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/orcamento.pdf");
    await file.writeAsBytes(await pdf.save());

    _compartilharPdf(file);
  }

  void _compartilharPdf(File file) async {
    final url = "https://wa.me/?text=Enviei o orçamento no PDF anexo.";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao abrir o WhatsApp.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gerar Orçamento")),
      body: servicos.isEmpty
          ? Center(child: Text("Nenhum serviço cadastrado"))
          : ListView.builder(
              itemCount: servicos.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(servicos[index].nome),
                  subtitle:
                      Text("R\$ ${servicos[index].valor.toStringAsFixed(2)}"),
                  value: selecionados[index],
                  onChanged: (bool? value) {
                    setState(() {
                      selecionados[index] = value!;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gerarPdf,
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
