import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart'; // Para formatar a data bonitinha

import '../models/servico_tomado.dart';
import '../models/cliente.dart';
import '../models/prestador.dart';

class PdfGenerator {
  static Future<pw.Document> gerarDocumento({
    required Cliente cliente,
    required Prestador prestador,
    required List<ServicoTomado> servicos,
  }) async {
    final pdf = pw.Document();
    
    // Calcula o total geral
    double totalGeral = 0;
    for (var servico in servicos) {
      totalGeral += servico.valor;
    }

    // Pega a data de hoje formatada
    final dataHoje = DateFormat('dd/MM/yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- TÍTULO (Com fundo cinza igual ao seu design original) ---
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                color: PdfColors.grey300,
                child: pw.Text(
                  "Orçamento - Serviços de Pintura",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // --- DADOS DO CLIENTE E PRESTADOR ---
              pw.Text("Cliente: ${cliente.nome}", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),
              pw.Text("Prestador: ${prestador.nome}", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text("Telefone: ${prestador.telefone}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              
              // Data alinhada à direita
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text("Data: $dataHoje", style: const pw.TextStyle(fontSize: 10)),
              ),
              pw.SizedBox(height: 10),

              // --- TABELA DE SERVIÇOS ---
              pw.TableHelper.fromTextArray(
                headers: ['Serviço', 'Qtde', 'Unitário', 'Subtotal'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellAlignment: pw.Alignment.center,
                cellAlignments: {
                  0: pw.Alignment.centerLeft, // Nome do serviço alinhado à esquerda
                },
                data: servicos.map((servico) {
                  return [
                    servico.nome,
                    '1', // Considerando 1 como padrão para serviço de pintura
                    'R\$ ${servico.valor.toStringAsFixed(2)}',
                    'R\$ ${servico.valor.toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              
              pw.SizedBox(height: 20),

              // --- TOTAL GERAL (Em verde!) ---
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total Geral: R\$ ${totalGeral.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16, 
                    fontWeight: pw.FontWeight.bold, 
                    color: PdfColors.green700, // O verde corporativo
                  ),
                ),
              ),
              pw.Divider(thickness: 1),
              
              pw.Spacer(),

              // --- RODAPÉ ---
              pw.Center(
                child: pw.Text(
                  "Obrigado por confiar em nossos serviços!",
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}