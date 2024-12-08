import 'dart:convert';

import 'package:aica_app/features/auth/domain/providers/auth_provider.dart';
import 'package:aica_app/features/auth/domain/states/auth_state.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/common/navigation_buttons.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/common/step_progress_indicator.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/instagram_connect_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/subjects_selection_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/tone_selection_step.dart';
import 'package:aica_app/features/auth/presentation/widgets/profile_complete/steps/user_name_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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

  final GlobalKey<FormState> _formUserNameStep = GlobalKey<FormState>();
  final GlobalKey<FormState> _formToneSelectionStep = GlobalKey<FormState>();
  final GlobalKey<FormState> _formSubjectsStep = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(); // Contrôleur pour surveiller le texte
  String _name = '';

  final List<String> _selectedTone = [];
  final List<String> _selectedSubjects = [];

  bool isLoading = false;

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return _formUserNameStep.currentState?.validate() ?? false;
      case 2:
        if (_selectedTone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Veuillez sélectionner au moins un ton')));
          return false;
        } else {
          return true;
        }
      case 4:
        if (_selectedSubjects.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Veuillez ajouter au moins un item')));
          return false;
        } else {
          return true;
        }
      default:
        return true;
    }
  }

  Future<void> _handleNext() async {
    FocusScope.of(context).unfocus();
    if (_validateCurrentStep()) {
      if (currentStep == 0) {
        await _createUser(ref);
      }

      if (currentStep < 7) {
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

  void _handleError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _createUser(WidgetRef ref) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authState = ref.read(authProvider);

      final url = Uri.parse("${dotenv.env['API_URL']}/users/create");

      await http.post(url,
          headers: {
            'Authorization': 'Bearer ${authState.user!.token}',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": _name,
          }));
    } catch (e) {
      _handleError(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleInstagramConnect() async {
    // Logique de connexion Instagram
  }

  Future<void> _submitProfile() async {
    // Soumission du profil complet
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
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
                      UserNameStep(
                        formKey: _formUserNameStep,
                        controller: _nameController,
                        onNameChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      const InstagramConnectStep(),
                      ToneSelectionStep(
                        formKey: _formToneSelectionStep,
                        selectedTone: _selectedTone,
                      ),
                      const InstagramConnectStep(
                        retry: true,
                      ),
                      SubjectsStep(
                          formKey: _formSubjectsStep,
                          selectedSubjects: _selectedSubjects)
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
            if (isLoading)
              Container(
                color: Colors.black, // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
