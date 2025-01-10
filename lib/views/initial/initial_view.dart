import 'package:challenges_taski/core/services/service_locator.dart';
import 'package:challenges_taski/models/user.dart';
import 'package:challenges_taski/views/home/home_view.dart';
import 'package:challenges_taski/views/widgets/custom_button.dart';
import 'package:challenges_taski/views/widgets/logo.dart';
import 'package:flutter/material.dart';

class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  late User? user;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Durations.medium1,
      () => _loadUserName(),
    );
  }

  Future<void> _loadUserName() async {
    await ServiceLocator().userViewModel.getCachedUser();
    setState(() {
      user = ServiceLocator().userViewModel.user;
    });

    if (user != null) {
      _navigateToMainScreen();
    }
  }

  void _navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeView(
          userName: user!.name,
          profileImageUrl: '',
          userId: user?.uuid ?? '',
          todoViewModel: ServiceLocator().todoViewModel,
          onTapCreateTask: ServiceLocator().todoViewModel.createTask,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    String? errorText;

    @override
    void dispose() {
      nameController.dispose();
      emailController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Logo(
              logoAlignment: MainAxisAlignment.center,
              scale: 1.5, // Adjust the scale as needed
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();

                if (name.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                  return;
                }

                try {
                  final success = await ServiceLocator()
                      .userViewModel
                      .createUser(email, name);

                  if (success) {
                    setState(() {
                      user = ServiceLocator().userViewModel.user;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário salvo com sucesso!'),
                      ),
                    );

                    // Adicionando um delay de 2 segundos antes de navegar
                    await Future.delayed(const Duration(seconds: 2));
                    _navigateToMainScreen();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Não foi possível salvar o usuário.'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: ${e.toString()}')),
                  );
                }
              },
              text: 'Entrar',
            ),
          ],
        ),
      ),
    );
  }
}
