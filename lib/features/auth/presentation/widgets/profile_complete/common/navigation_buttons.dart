import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLastStep;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onBack,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: currentStep > 0
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (currentStep > 0)
            TextButton(
              onPressed: onBack,
              child: const Text('Retour'),
            ),
          ElevatedButton(
            onPressed: onNext,
            child: Text(getButtonText()),
          ),
        ],
      ),
    );
  }

  String getButtonText() {
    if (currentStep == 1) {
      return 'Plus tard';
    }
    return isLastStep ? 'Terminer' : 'Suivant';
  }
}
