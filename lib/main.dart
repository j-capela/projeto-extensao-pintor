import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
// IMPORTANTE: Importe os seus modelos aqui

import 'models/cliente.dart';
import 'models/prestador.dart';
import 'models/servico_tomado.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // --- A CORREÇÃO DO ERRO VERMELHO ---
  // Avisamos ao banco de dados como ler as nossas classes
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(PrestadorAdapter());
  Hive.registerAdapter(ServicoTomadoAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Pintor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}