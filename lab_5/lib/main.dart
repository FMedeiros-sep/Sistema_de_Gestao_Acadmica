import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Acadêmico',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF38BDF8),
        ),
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
    );
  }
}

// ==========================================
// TELA DE AUTENTICAÇÃO
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _mostrarSenha = false;
  bool _carregando = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  static const String _chaveBancoUsuarios = 'banco_usuarios_prefs';

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _carregarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    String? dadosJson = prefs.getString(_chaveBancoUsuarios);

    if (dadosJson != null && dadosJson.isNotEmpty) {
      try {
        Map<String, dynamic> mapaBruto = jsonDecode(dadosJson);
        return mapaBruto.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        debugPrint("Erro ao decodificar usuários: $e");
      }
    }
    return {};
  }

  Future<void> _salvarUsuario(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> usuarios = await _carregarUsuarios();
    usuarios[email] = senha;
    await prefs.setString(_chaveBancoUsuarios, jsonEncode(usuarios));
  }

  void _efetuarAutenticacao() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      String email = _emailController.text.trim().toLowerCase();
      String senha = _senhaController.text;

      Map<String, String> usuarios = await _carregarUsuarios();

      setState(() => _carregando = false);

      if (isLogin) {
        if (usuarios.containsKey(email) && usuarios[email] == senha) {
          String nomeUsuario = _nomeController.text.isNotEmpty
              ? _nomeController.text
              : email.split('@').first;

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(nomeUsuario: nomeUsuario),
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail ou senha incorretos!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        if (usuarios.containsKey(email)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este e-mail já está cadastrado!'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        } else {
          await _salvarUsuario(email, senha);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro realizado com sucesso! Faça seu login.'),
              backgroundColor: Colors.green,
            ),
          );

          setState(() {
            isLogin = true;
            _senhaController.clear();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('fundo.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.6),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLogin
                          ? 'Entre com seu e-mail e senha para acessar'
                          : 'Preencha os dados para realizar o cadastro',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isLogin
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isLogin ? Colors.white : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isLogin
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        !isLogin ? Colors.white : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!isLogin) ...[
                            _buildTextField(
                              controller: _nomeController,
                              label: 'Nome Completo',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                          ],
                          _buildTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _senhaController,
                            label: 'Senha',
                            icon: Icons.lock_outline,
                            isObscure: !_mostrarSenha,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _mostrarSenha
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarSenha = !_mostrarSenha;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        onPressed: _carregando ? null : _efetuarAutenticacao,
                        child: _carregando
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                isLogin ? 'ENTRAR' : 'CRIAR CONTA',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.45),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, informe $label';
        }
        return null;
      },
    );
  }
}

// ==========================================
// TELA PRINCIPAL (HOME)
// ==========================================
class HomeScreen extends StatelessWidget {
  final String nomeUsuario;

  const HomeScreen({super.key, required this.nomeUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      const Color(0xFF4F46E5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${nomeUsuario.toUpperCase()}! 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Seja muito bem-vindo ao seu painel acadêmico!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Módulos de Acesso',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard(
                    context,
                    titulo: 'Secretaria',
                    subtitulo: 'Avisos e Diretrizes',
                    icone: Icons.admin_panel_settings_outlined,
                    cor: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecretariaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    titulo: 'Matrículas',
                    subtitulo: 'Cadastrar novos alunos',
                    icone: Icons.how_to_reg_outlined,
                    cor: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatriculaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    titulo: 'Alunos',
                    subtitulo: 'Lista de Cadastrados',
                    icone: Icons.people_alt_outlined,
                    cor: const Color(0xFF38BDF8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlunosScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    titulo: 'Financeiro',
                    subtitulo: 'Status de Pagamentos',
                    icone: Icons.account_balance_wallet_outlined,
                    cor: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinanceiroScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: cor, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MÓDULO 1: SECRETARIA (Avisos/Normas)
// ==========================================
class SecretariaScreen extends StatelessWidget {
  const SecretariaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secretaria')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Card(
              color: Color(0xFF1E293B),
              child: ListTile(
                leading: Icon(Icons.info, color: Color(0xFF6366F1)),
                title: Text('Horário de Atendimento'),
                subtitle: Text('Segunda a Sexta: 08:00 - 18:00'),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              color: Color(0xFF1E293B),
              child: ListTile(
                leading: Icon(Icons.campaign, color: Color(0xFFF59E0B)),
                title: Text('Comunicado de Provas'),
                subtitle: Text('As avaliações do 1º Semestre iniciam dia 10.'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF1E293B),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                title: const Text('Regimento Interno.pdf'),
                subtitle: const Text('Clique para visualizar'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo documento...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MÓDULO 2: MATRÍCULAS (Adicionar Aluno)
// ==========================================
class MatriculaScreen extends StatefulWidget {
  const MatriculaScreen({super.key});

  @override
  State<MatriculaScreen> createState() => _MatriculaScreenState();
}

class _MatriculaScreenState extends State<MatriculaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cursoController = TextEditingController();

  Future<void> _salvarAluno() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String? listaJson = prefs.getString('banco_alunos');
      List<dynamic> alunos = listaJson != null ? jsonDecode(listaJson) : [];

      alunos.add({
        'nome': _nomeController.text.trim(),
        'curso': _cursoController.text.trim(),
        'statusPagamento': 'Pendente',
      });

      await prefs.setString('banco_alunos', jsonEncode(alunos));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aluno matriculado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      _nomeController.clear();
      _cursoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Matrícula')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo do Aluno',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cursoController,
                decoration: const InputDecoration(
                  labelText: 'Curso / Turma',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o curso' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                  ),
                  onPressed: _salvarAluno,
                  child: const Text(
                    'EFETUAR MATRÍCULA',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MÓDULO 3: ALUNOS (Consultar/Excluir)
// ==========================================
class AlunosScreen extends StatefulWidget {
  const AlunosScreen({super.key});

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {
  List<dynamic> _alunos = [];

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    String? listaJson = prefs.getString('banco_alunos');
    if (listaJson != null) {
      setState(() {
        _alunos = jsonDecode(listaJson);
      });
    }
  }

  Future<void> _removerAluno(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _alunos.removeAt(index);
    await prefs.setString('banco_alunos', jsonEncode(_alunos));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Alunos')),
      body: _alunos.isEmpty
          ? const Center(child: Text('Nenhum aluno matriculado.'))
          : ListView.builder(
              itemCount: _alunos.length,
              itemBuilder: (context, index) {
                final aluno = _alunos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF38BDF8),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(aluno['nome']),
                    subtitle: Text('Curso: ${aluno['curso']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removerAluno(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// MÓDULO 4: FINANCEIRO (Alterar Status)
// ==========================================
class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  List<dynamic> _alunos = [];

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    String? listaJson = prefs.getString('banco_alunos');
    if (listaJson != null) {
      setState(() {
        _alunos = jsonDecode(listaJson);
      });
    }
  }

  Future<void> _alternarPagamento(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String statusAtual = _alunos[index]['statusPagamento'] ?? 'Pendente';
    _alunos[index]['statusPagamento'] =
        statusAtual == 'Pago' ? 'Pendente' : 'Pago';

    await prefs.setString('banco_alunos', jsonEncode(_alunos));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão Financeira')),
      body: _alunos.isEmpty
          ? const Center(child: Text('Nenhum aluno cadastrado para cobrança.'))
          : ListView.builder(
              itemCount: _alunos.length,
              itemBuilder: (context, index) {
                final aluno = _alunos[index];
                bool isPago = aluno['statusPagamento'] == 'Pago';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    title: Text(aluno['nome']),
                    subtitle: Text('Status: ${aluno['statusPagamento']}'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPago ? Colors.green : Colors.amber,
                      ),
                      onPressed: () => _alternarPagamento(index),
                      child: Text(
                        isPago ? 'PAGO' : 'PENDENTE',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}