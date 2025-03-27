import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegistering = false;

  void _toggleMode() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final db = DatabaseHelper.instance;

    if (_isRegistering) {
      final existingUser = await db.getUserByEmail(email);
      if (existingUser != null) {
        _showError('Email already registered');
        return;
      }

      final user = User(name: name, email: email, password: password);
      final userId = await db.insertUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => MyHomePage(
                title: '$name ($email)',
                currentUser: user.copyWith(id: userId),
              ),
        ),
      );
    } else {
      final user = await db.getUserByEmail(email);
      if (user == null || user.password != password) {
        _showError('Invalid email or password');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  MyHomePage(title: 'Welcome, ${user.name}', currentUser: user),
        ),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegistering ? 'Register' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (_isRegistering)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) => value!.isEmpty ? 'Enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) => value!.isEmpty ? 'Enter your password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isRegistering ? 'Register' : 'Login'),
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(
                  _isRegistering
                      ? 'Already have an account? Login'
                      : 'No account? Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on User {
  User copyWith({int? id, String? name, String? email, String? password}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
