import 'package:aica_app/features/auth/domain/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLoadingWrapper extends ConsumerWidget {
  final Widget child;

  const AuthLoadingWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(authProvider.select((state) => state.isLoading));

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black, // Semi-transparent background
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
