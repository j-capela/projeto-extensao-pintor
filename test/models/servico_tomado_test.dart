import 'package:flutter_test/flutter_test.dart';
// ATENÇÃO: Verifique se este caminho está certinho igual no seu projeto
import 'package:app_pintor/models/servico_tomado.dart';

void main() {
  group('Testes de Unidade - Modelo ServicoTomado', () {
    
    test('Deve validar um serviço correto sem retornar erros', () {
      final servico = ServicoTomado(
        nome: 'Pintura Externa',
        descricao: 'Pintura da fachada com duas demãos de tinta acrílica',
        valor: 1500.50,
      );

      final erros = servico.validar();

      expect(erros.isEmpty, true, reason: 'Um serviço válido não deve ter erros.');
    });

    test('Deve bloquear a criação de serviço com nome vazio', () {
      final servico = ServicoTomado(
        nome: '   ', 
        descricao: 'Pintura da sala',
        valor: 450.00,
      );

      final erros = servico.validar();

      expect(erros.isNotEmpty, true);
      expect(erros.contains("O nome do serviço não pode ser vazio."), true);
    });

    test('Deve bloquear a criação de serviço com descrição vazia', () {
      final servico = ServicoTomado(
        nome: 'Textura na Parede',
        descricao: '', // Descrição em branco
        valor: 800.00,
      );

      final erros = servico.validar();

      expect(erros.isNotEmpty, true);
      expect(erros.contains("A descrição do serviço é obrigatória."), true);
    });

    test('Deve bloquear serviços com valor zerado ou negativo', () {
      // Testando cenário com zero
      final servicoZero = ServicoTomado(
        nome: 'Orçamento',
        descricao: 'Visita técnica',
        valor: 0.0,
      );
      
      // Testando cenário negativo (ex: erro de digitação do usuário)
      final servicoNegativo = ServicoTomado(
        nome: 'Pintura Portão',
        descricao: 'Pintura com esmalte sintético',
        valor: -150.0,
      );

      final errosZero = servicoZero.validar();
      final errosNegativo = servicoNegativo.validar();

      expect(errosZero.contains("O valor do serviço deve ser maior que zero."), true);
      expect(errosNegativo.contains("O valor do serviço deve ser maior que zero."), true);
    });
  });
}