import 'package:flutter/material.dart';

class InstagramConnectStep extends StatelessWidget {
  final bool retry;

  const InstagramConnectStep({
    super.key,
    this.retry = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              retry
                  ? "Toujours pas envie de te connecter a Instagram ?"
                  : "On se connecte a ton compte Instagram ?",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {},
                child:
                    Text(retry ? "Aller ça part !" : "Direction L'espace !")),
          ],
        ));
  }
}
