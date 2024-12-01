import 'package:aica_app/config/theme/app_theme.dart';
import 'package:aica_app/features/auth/domain/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool isChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authProvider.notifier).signUpWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _signupWithGoogle() async {
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
                                Text("Créez un compte,",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        fontFamily: "Rouna",
                                        fontSize: 28)),
                                Text("et commencez maintenant !",
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
                                    validator: _validateEmail,
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
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                      ),
                                    ),
                                    validator: _validatePassword,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_isConfirmPasswordVisible,
                                    cursorColor:
                                        Theme.of(context).colorScheme.surface,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    decoration:
                                        authTextFieldDecoration.copyWith(
                                      labelText: "Confirm Password",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                            _isConfirmPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                      ),
                                    ),
                                    validator: _validateConfirmPassword,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) =>
                                            setState(() => isChecked = value!),
                                        fillColor: const WidgetStatePropertyAll(
                                            Colors.white),
                                        checkColor: Colors.black,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      Text(
                                          "J'accepte les cgu et la politique de confidentialité",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          )),
                                    ],
                                  )
                                ],
                              )),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              _signup();
                            },
                            child: const Text("S'inscrire"),
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
                              'Ou inscrivez-vous avec',
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
                                _signupWithGoogle();
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
                              text: "Déjà un compte ? ",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Stack(
                                children: [
                                  TextButton(
                                      onPressed: () =>
                                          context.go('/auth/login'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "Connectez-vous",
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
