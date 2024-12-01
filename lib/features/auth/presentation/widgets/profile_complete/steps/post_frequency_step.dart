import 'package:flutter/material.dart';

class PostFrequencyStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic>) onSaved;

  const PostFrequencyStep({
    super.key,
    required this.formKey,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Ce champ est requis' : null,
            onSaved: (value) => onSaved({'lastName': value}),
          ),
        ],
      ),
    );
  }
}
