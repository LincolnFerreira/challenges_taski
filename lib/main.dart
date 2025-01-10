import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/services/service_locator.dart';
import 'core/theme/custom_color.dart';
import 'views/initial/initial_view.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final serviceLocator = ServiceLocator();
  serviceLocator.initialize(firestore: FirebaseFirestore.instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taski',
      theme: ThemeData(
        primarySwatch: CustomColor.primarySwatch,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: CustomColor.primary,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Fundo cinza quando desativado
            }
            return Colors.white; // Fundo sempre branco
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.primary), // Cor da borda
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColor.primary), // Cor da borda quando focado
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: CustomColor.primary, // Cor do cursor
          selectionColor:
              CustomColor.primary.withOpacity(0.3), // Cor da seleção (opcional)
          selectionHandleColor: CustomColor.primary, // Cor do seletor de texto
        ),
      ),
      home: const InitialView(),
    );
  }
}
