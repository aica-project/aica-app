import 'package:flutter/material.dart';

class SubjectsStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<String> selectedSubjects;

  const SubjectsStep({
    super.key,
    required this.formKey,
    required this.selectedSubjects,
  });

  @override
  SubjectsStepState createState() => SubjectsStepState();
}

class SubjectsStepState extends State<SubjectsStep> {
  final TextEditingController _textController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "De quels sujets/thématiques parles-tu ?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: _textController,
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                            hintText: "Entrez un sujet...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSubmitted: (_) {
                            _addSubject();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addSubject,
                      child: const Text("Ajouter"),
                    ),
                  ],
                ),
                if (_errorMessage != null)
                  Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: widget.selectedSubjects
                      .map((subject) => Chip(
                            label: Text(subject),
                            onDeleted: () => _removeSubject(subject),
                          ))
                      .toList(),
                ),
              ],
            )));
  }

  void _addSubject() {
    final subject = _textController.text.trim();

    if (subject.isEmpty) {
      setState(() {
        _errorMessage = "Le champ ne peut pas être vide.";
      });
      return;
    }

    if (widget.selectedSubjects.contains(subject)) {
      setState(() {
        _errorMessage = "Cet item existe déjà...";
      });
      return;
    }

    setState(() {
      widget.selectedSubjects.add(subject);
      _textController.clear();
    });

    _errorMessage = null;
  }

  /// Supprime un sujet de la liste
  void _removeSubject(String subject) {
    setState(() {
      widget.selectedSubjects.remove(subject);
    });
  }
}
