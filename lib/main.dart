// main.dart
//
// Entry point aplikasi FOTRIX Hydrogen Monitor.
// Di sini:
// 1. Init Flutter binding
// 2. Init Firebase (dipakai ControlPage untuk kontrol relay via Firestore)
// 3. Load SharedPreferences (cek apakah intro sudah pernah dilihat)
// 4. Jalankan FotrixApp dengan halaman awal sesuai flag intro

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tema global & halaman-halaman utama
import 'theme/app_theme.dart';
import 'screens/startup_page.dart';
import 'screens/data_page.dart';
import 'screens/control_page.dart';
import 'screens/about_page.dart';

Future<void> main() async {
  // Logging: aplikasi mulai booting
  print("🔧 [main] Starting FOTRIX app…");

  // Wajib sebelum Firebase & async things
  WidgetsFlutterBinding.ensureInitialized();
  print("🔧 [main] Flutter binding initialized");

  // Inisialisasi Firebase (dipakai di ControlPage, dst.)
  print("🔥 [main] Initializing Firebase…");
  await Firebase.initializeApp();
  print("🔥 [main] Firebase initialization DONE");

  // SharedPreferences: cek apakah intro sudah pernah dilihat
  print("📦 [main] Loading SharedPreferences…");
  final prefs = await SharedPreferences.getInstance();
  final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  print("📦 [main] hasSeenIntro = $hasSeenIntro");

  // Jalankan aplikasi utama
  print("🚀 [main] Launching FOTRIX AppShell…");
  runApp(FotrixApp(hasSeenIntro: hasSeenIntro));
}

class FotrixApp extends StatelessWidget {
  final bool hasSeenIntro;
  const FotrixApp({super.key, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FOTRIX Hydrogen Monitor',
      theme: AppTheme.darkTheme,
      // Jika user belum pernah lihat intro, buka StartupPage
      home: hasSeenIntro ? const AppShell() : const StartupPage(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  // Helper statis untuk akses state dari halaman lain
  static _AppShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppShellState>();

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Index tab yang sedang aktif:
  /// 0 = DataPage
  /// 1 = ControlPage
  /// 2 = AboutPage
  int _index = 0;

  // Fungsi untuk ganti tab dari luar (kalau dibutuhkan)
  void switchTo(int index) {
    print("🔀 [AppShell] Switching tab to index: $index");
    setState(() => _index = index);
  }

  // Daftar halaman sesuai urutan navigation bar
  final List<Widget> _pages = const [
    DataPage(),    // boleh dummy / offline
    ControlPage(), // pakai Firestore untuk kontrol relay
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _pages[_index],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          print("🔘 [NavigationBar] Destination selected: $i");
          setState(() => _index = i);
        },
        height: 72,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.show_chart_rounded, color: cs.secondary),
            selectedIcon: Icon(Icons.show_chart_rounded, color: cs.primary),
            label: 'Data',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: cs.secondary),
            selectedIcon: Icon(Icons.settings_rounded, color: cs.primary),
            label: 'Kendali',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded, color: cs.secondary),
            selectedIcon: Icon(Icons.info_rounded, color: cs.primary),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}
