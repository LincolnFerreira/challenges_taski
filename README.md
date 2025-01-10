## Projeto: [Nome do Seu Projeto]

### Descrição
Este é um aplicativo desenvolvido como parte do desafio proposto no repositório [WL-Consultings Challenges](https://github.com/WL-Consultings/challenges/tree/main/mobile). O projeto utiliza a arquitetura MVVM com Repository Pattern, garantindo organização e escalabilidade do código.

---

### Funcionalidades
- **[Funcionalidade 1]:** **"Login"** com e-mail (apenas para manter um suposto repositorio remoto com id do usuário)
- **[Funcionalidade 2]:** **Cadastro, Exclusão, Edição de conclusão e Visão das tarefas**
- **[Funcionalidade 3]:** **Offline** first contemplando a funcionalidade do aplicativo sem internet
- **[Funcionalidade 4]:** **Sincronização** das tarefas com o servidor a cada 3 minutos
- **[Funcionalidade 5]:** **Cadastro** de tarefas, exclusão de uma ou todas tarefas
- **[Funcionalidade 6]:** **Cadastro** de tarefas, exclusão de uma ou todas tarefas
- **[Funcionalidade 7]:** **Pesquisa** para encontrar tarefas pelo nome

#### O que poderia ser melhorado?
- **Melhoria 1:** Customização de foto de perfil
- **Melhoria 2:** Login
- **Melhoria 3:** Implementação de testes para a camada de User
- **Melhoria 4:** Edição de titulo e/ou descrição da tarefa

---

### Tecnologias utilizadas
- Flutter
- Dart
- Arquitetura MVVM com Repository
- Testes unitários (utilizando [mocktail])

---

### Estrutura do Projeto
```
lib/
├── core/
│   ├── services/
│   └── theme/
├── data/
│   ├── local/
│   └── remote/
├── models/
│   ├── task.dart
│   └── user.dart
├── repositories/
│   ├── task_repository.dart
│   ├── task_repository_impl.dart
│   └── user_repository_impl.dart
├── view_models/
│   ├── todo_view_model.dart
│   └── user_view_model.dart
├── views/
│   ├── home/
│   │   ├── pages/
│   │   │   ├── done_view.dart
│   │   │   ├── search_view.dart
│   │   │   ├── todo_view.dart
│   │   │   └── home_view.dart
│   └── login/
├── widgets/
├── firebase_options.dart
└── main.dart
```
**Padrão MVVM:**
- **Models:** Contêm as classes que representam os dados do aplicativo.
- **Views:** Componentes responsáveis pela interface do usuário.
- **ViewModels:** Controlam a lógica de negócios e atualizam as Views conforme necessário.
- **Repositories:** Realizam a comunicação com a camada de dados (local ou remoto).

---

### Como iniciar o projeto

#### Pré-requisitos
- Flutter instalado ([Guia de instalação](https://docs.flutter.dev/get-started/install))
- Um editor de texto ou IDE (VS Code, Android Studio, etc.)
- Dispositivo físico ou emulador configurado

#### Passos para rodar o projeto
1. Clone o repositório:
   ```bash
   git clone https://github.com/LincolnFerreira/challenges_taski.git
   cd [challenges_taski]
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute o projeto:
   ```bash
   flutter run
   ```

---

### Testes
O projeto inclui testes unitários para validar a lógica de negócios. Para executar os testes, use:
```bash
flutter test
```

---

### Comentários sobre o desafio
- **O que foi aprendido:** Esse desafio foi uma ótima oportunidade para me aprofundar no uso do ChangeNotifier. Já tinha usado antes, mas nunca de forma tão prática e consistente. Também consegui revisitar a arquitetura MVVM, além de afirmar mais a minha base de conhecimento com flutter.

- **Dificuldades superadas:** A implementação do offline first foi algo que já havia tentado fazer antes, mas agora, com mais experiência, achei sensacional a sensação de realizar a sincronização, a troca de dados entre local e remoto e, de fato, utilizar a camada de repository para integrar essas duas implementações.

---
