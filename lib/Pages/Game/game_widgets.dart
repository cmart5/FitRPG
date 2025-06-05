import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const GameOverOverlay({
    Key? key,
    required this.onRetry,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black.withAlpha(200),
        margin: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Game Over", style: TextStyle(color: Colors.white, fontSize: 32)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Try Again"),
              ),
              ElevatedButton(
                onPressed: onExit,
                child: const Text("Back to Hub"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
