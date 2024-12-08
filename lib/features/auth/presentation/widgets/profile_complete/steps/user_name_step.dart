import 'package:flutter/material.dart';

class UserNameStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function(String) onNameChanged;

  const UserNameStep({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Quel est ton nom ?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                      labelText: "Je m'appelle...", hintText: "Teuse !"),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  onChanged: onNameChanged,
                ),
              ],
            )));
  }
}
