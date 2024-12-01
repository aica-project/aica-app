import 'package:aica_app/features/auth/presentation/widgets/profile_complete/common/navigation_buttons.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/common/step_progress_indicator.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/instagram_connect_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/post_frequency_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/style_selection_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/subjects_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/tone_selection.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/user_profile_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final PageController _pageController = PageController();
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  Map<String, dynamic> profileData = {};

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Configuration du profil'),
        ),
        body: Column(
          children: [
            StepProgressIndicator(
              currentStep: currentStep,
              totalSteps: 6,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  UserProfileStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  ),
                  InstagramConnectStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  ),
                  ToneSelectionStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  ),
                  SubjectsStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  ),
                  PostFrequencyStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  ),
                  StyleSelectionStep(
                    formKey: formKey,
                    onSaved: (data) => profileData.addAll(data),
                  )
                ],
              ),
            ),
            NavigationButtons(
              currentStep: currentStep,
              onNext: _handleNext,
              onBack: _handleBack,
              isLastStep: currentStep == 5,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (currentStep == 0 && !formKey.currentState!.validate()) return;

    if (currentStep < 5) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitProfile();
    }
  }

  void _handleBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleInstagramConnect() async {
    // Logique de connexion Instagram
  }

  Future<void> _submitProfile() async {
    // Soumission du profil complet
  }
}
