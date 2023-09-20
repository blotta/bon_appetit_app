import 'dart:async';

import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passVisible = false;
  bool _registerMode = false;

  bool _loading = false;

  login() async {
    try {
      setState(() {
        _loading = true;
      });
      await ref.read(authProvider.notifier).loginWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
    } catch (e) {
      if (context.mounted) {
        showErrorSnackbar(context, "Erro ao realizar o login");
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  register() async {
    try {
      setState(() {
        _loading = true;
      });
      var success =
          await ref.read(authProvider.notifier).registerWithEmailAndPassword(
                _nameController.text,
                _emailController.text,
                _passwordController.text,
              );
      if (!success) {
        throw Exception('Erro ao registrar');
      }
      await ref.read(authProvider.notifier).loginWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
    } catch (e) {
      if (context.mounted) {
        showErrorSnackbar(context, "Erro ao registrar usuário");
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.loggedIn) {
      var duration = const Duration(seconds: 1);
      Timer(duration, navigateBack);
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // login mode
    Widget content = Form(
      key: _loginFormKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          'Faça o login',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            label: Text('e-mail'),
            hintText: 'nome@email.com',
          ),
          validator: (email) {
            if (email == null || email.isEmpty) {
              return 'Digite seu email';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: !_passVisible,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            label: const Text('senha'),
            hintText: 'Digite sua senha',
            suffixIcon: IconButton(
              icon: Icon(_passVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () {
                setState(() {
                  _passVisible = !_passVisible;
                });
              },
            ),
          ),
          validator: (senha) {
            if (senha == null || senha.isEmpty) {
              return 'Digite sua senha';
            } else if (senha.length < 6) {
              return 'Digite uma senha mais forte';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        _loading
            ? const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    login();
                  }
                },
                child: Text('ENTRAR',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white)),
              ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _registerMode = true;
              });
            },
            child: const Text('Registrar'),
          ),
        )
      ]),
    );

    if (_registerMode) {
      content = Form(
        key: _registerFormKey,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'Crie sua conta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('nome'),
              hintText: 'nome',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite seu nome';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('e-mail'),
              hintText: 'nome@email.com',
            ),
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Digite seu email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: !_passVisible,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              label: const Text('senha'),
              hintText: 'Digite sua senha',
              suffixIcon: IconButton(
                icon: Icon(_passVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () {
                  setState(() {
                    _passVisible = !_passVisible;
                  });
                },
              ),
            ),
            validator: (senha) {
              if (senha == null || senha.isEmpty) {
                return 'Digite sua senha';
              } else if (senha.length < 6) {
                return 'Digite uma senha mais forte';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              label: Text('confirmação de senha'),
              hintText: 'Confirme sua senha',
            ),
            validator: (senha) {
              if (senha == null || senha.isEmpty) {
                return 'Digite sua senha';
              } else if (senha.length < 6) {
                return 'Digite uma senha mais forte';
              } else if (senha != _passwordController.text) {
                return 'Campo da senha difere';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          _loading
              ? const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () {
                    if (_registerFormKey.currentState!.validate()) {
                      register();
                    }
                  },
                  child: Text('REGISTRAR',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white)),
                ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _registerMode = false;
                });
              },
              child: const Text('Login'),
            ),
          )
        ]),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), child: content),
      ),
    );
  }
}
