import 'package:flutter_test/flutter_test.dart';
// ATENÇÃO: Ajuste o import abaixo para o caminho correto do seu projeto
import 'package:app_pintor/models/cliente.dart'; 

void main() {
  group('Testes de Unidade - Modelo Cliente', () {
    
    test('Deve validar um cliente com dados corretos sem retornar erros', () {
      // 1. Preparação (Arrange)
      final cliente = Cliente(
        nome: 'Carlos Souza',
        telefone: '11988887777',
        endereco: 'Rua das Tintas, 123',
      );

      // 2. Execução (Act)
      final erros = cliente.validar();

      // 3. Verificação (Assert)
      expect(erros.isEmpty, true, reason: 'A lista de erros deveria estar vazia para dados válidos.');
      expect(cliente.nome, 'Carlos Souza');
    });

    test('Deve bloquear a criação de cliente com nome vazio', () {
      final cliente = Cliente(
        nome: '   ', // Nome só com espaços
        telefone: '11988887777',
        endereco: 'Rua das Tintas, 123',
      );

      final erros = cliente.validar();

      expect(erros.isNotEmpty, true);
      expect(erros.contains("O nome do cliente não pode ser vazio."), true);
    });

    test('Deve bloquear a criação de cliente com telefone muito curto', () {
      final cliente = Cliente(
        nome: 'Mariana',
        telefone: '123', // Telefone inválido
        endereco: 'Avenida Central, 45',
      );

      final erros = cliente.validar();

      expect(erros.isNotEmpty, true);
      expect(erros.contains("Telefone inválido. Insira um número válido."), true);
    });
  });
}