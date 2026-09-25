import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === Logo Container ===
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.2),
                      cs.primaryContainer.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/LogoPKM.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // === Title ===
              Text(
                'FOTRIX',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 8),

              // === Subtitle ===
              Text(
                'Portable solar-powered seawater hydrogen monitor',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),

              const SizedBox(height: 32),

              // === Button ===
              FilledButton.icon(
                onPressed: () {
                  AppShell.of(context)?.switchTo(0);
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Get Started'),
              ),

              const SizedBox(height: 48),

              // === About Section ===
              Text(
                'About Our Team',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'We are a multidisciplinary group of engineers and innovators '
                    'developing FOTRIX — an integrated solar-powered system for '
                    'hydrogen production and microplastic degradation. '
                    'Our mission is to contribute to cleaner energy and ocean sustainability.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70, height: 1.5),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
