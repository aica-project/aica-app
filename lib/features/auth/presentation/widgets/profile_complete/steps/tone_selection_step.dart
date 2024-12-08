import 'package:flutter/material.dart';

class ToneSelectionStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<String> selectedTone;

  const ToneSelectionStep({
    super.key,
    required this.formKey,
    required this.selectedTone,
  });

  @override
  ToneSelectionStepState createState() => ToneSelectionStepState();
}

class ToneSelectionStepState extends State<ToneSelectionStep> {
  final List<String> _options = [
    'Professionnel',
    'Humoristique',
    'Inspirant/Motivant',
    'Décontracté/Informel',
    'Éducatif',
    'Provocateur/Rebelle',
    'Émotionnel',
    'Luxueux/Élitiste',
    'Créatif',
    'Solidaire/Humain',
    'Minimaliste',
    'Exclusif',
    'Authentique',
    'Interrogatif',
    'Trendy/Branché',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sur quel ton parles-tu a ton audience ?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 colonnes
                      crossAxisSpacing: 16.0, // Espacement horizontal
                      mainAxisSpacing: 16.0, // Espacement vertical
                      childAspectRatio: 2 / 1, // Ratio largeur/hauteur
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      final isSelected = widget.selectedTone.contains(option);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedTone.remove(option);
                            } else {
                              widget.selectedTone.add(option);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.green[100] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected ? Colors.green : Colors.grey[300]!,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.green[700]
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }
}
