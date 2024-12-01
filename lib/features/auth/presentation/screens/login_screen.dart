import 'package:aica_app/config/theme/app_theme.dart';
import 'package:aica_app/features/auth/domain/providers/auth_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(100),
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
                Theme.of(context).colorScheme.primary.withAlpha(170),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text("Bienvenue,",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        fontFamily: "Rouna",
                                        fontSize: 28)),
                                Text("Content de vous voir !",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        fontSize: 28)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer une adresse email';
                                      }
                                      // Utilisation d'une expression régulière pour valider l'email
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Veuillez entrer une adresse email valide';
                                      }
                                      return null;
                                    },
                                    cursorColor:
                                        Theme.of(context).colorScheme.surface,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    decoration:
                                        authTextFieldDecoration.copyWith(
                                      labelText: "Email",
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    cursorColor:
                                        Theme.of(context).colorScheme.surface,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    decoration:
                                        authTextFieldDecoration.copyWith(
                                      labelText: "Password",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                            !_isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/forgot-password');
                                  },
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  )),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _login();
                            },
                            child: const Text("Se connecter"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 64),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface, // Couleur de la barre
                              thickness: 1, // Épaisseur de la barre
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Ou connectez-vous avec',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.surface,
                              thickness: 1, // Épaisseur de la barre
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _loginWithGoogle();
                              },
                              child: SvgPicture.asset(
                                "assets/icons/google-icon.svg",
                                height: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: SvgPicture.asset(
                                "assets/icons/apple-icon.svg",
                                height: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                              text: "Pas encore de compte ? ",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Stack(
                                children: [
                                  TextButton(
                                      onPressed: () =>
                                          context.go('/auth/signup'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "S'inscrire",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      )),
                                  Positioned(
                                      bottom: -1,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ))
                                ],
                              ))
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
