import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/brand_header.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final _db = FirebaseFirestore.instance;

  bool automatic = true;
  bool lightOn = false;
  bool pumpOn = false;
  bool roofConfigOn = false;
  bool isSending = false;

  /// 🔥 Kirim perintah ke Firestore (dibaca ESP)
  Future<void> _sendUpdateToFirestore() async {
    setState(() => isSending = true);

    try {
      await _db.collection("devices").doc("fotrix1").set({
        "systemOn": automatic,
        "lampOn": lightOn,
        "pumpOn": pumpOn,
        "roofOn": roofConfigOn,
        "timestamp": DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✔ Perintah terkirim ke perangkat"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("ERROR FIRESTORE: $e");
    }

    setState(() => isSending = false);
  }

  void _setLight(bool value) {
    setState(() => lightOn = value);
    _sendUpdateToFirestore();
  }

  void _setPump(bool value) {
    setState(() => pumpOn = value);
    _sendUpdateToFirestore();
  }

  void _setRoofConfig(bool value) {
    setState(() => roofConfigOn = value);
    _sendUpdateToFirestore();
  }

  void _setMode(bool value) {
    setState(() => automatic = value);
    _sendUpdateToFirestore();
  }

  void _sendTrackerCommand(String direction) {
    // Kalau tracker digunakan nanti:
    _db.collection("devices").doc("fotrix1").set({
      "trackerCommand": direction,
      "timestamp": DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Perintah tracker: $direction"),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disabled = automatic;

    return ListView(
      children: [
        const BrandHeader(title: 'Panel Kontrol'),

        // --- Mode Operasi ---
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_mode_rounded, color: cs.primary),
                    const SizedBox(width: 8),
                    Text('Mode Operasi',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text("Otomatis")),
                    ButtonSegment(value: false, label: Text("Manual")),
                  ],
                  selected: {automatic},
                  onSelectionChanged: (s) => _setMode(s.first),
                ),
                const SizedBox(height: 8),
                Text(
                  automatic
                      ? "Sistem berjalan otomatis."
                      : "Anda dapat mengatur lampu & pompa secara manual.",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),

        // --- Lampu ---
        Card(
          child: IgnorePointer(
            ignoring: disabled,
            child: Opacity(
              opacity: disabled ? 0.5 : 1,
              child: SwitchListTile(
                title: Row(
                  children: [
                    Icon(Icons.lightbulb_rounded, color: cs.primary),
                    const SizedBox(width: 8),
                    const Text("Lampu"),
                  ],
                ),
                value: lightOn,
                onChanged: _setLight,
              ),
            ),
          ),
        ),

        // --- Pompa ---
        Card(
          child: IgnorePointer(
            ignoring: disabled,
            child: Opacity(
              opacity: disabled ? 0.5 : 1,
              child: SwitchListTile(
                title: Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: cs.primary),
                    const SizedBox(width: 8),
                    const Text("Pompa"),
                  ],
                ),
                value: pumpOn,
                onChanged: _setPump,
              ),
            ),
          ),
        ),

        // --- Tracker ---
        Card(
          child: IgnorePointer(
            ignoring: disabled,
            child: Opacity(
              opacity: disabled ? 0.5 : 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.device_hub_rounded, color: cs.primary),
                        const SizedBox(width: 8),
                        Text("Solar Tracker",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _trackerButton(context,
                            icon: Icons.west_rounded,
                            label: "Kiri",
                            onTap: () => _sendTrackerCommand("left")),
                        _trackerButton(context,
                            icon: Icons.stop_rounded,
                            label: "Stop",
                            onTap: () => _sendTrackerCommand("stop")),
                        _trackerButton(context,
                            icon: Icons.east_rounded,
                            label: "Kanan",
                            onTap: () => _sendTrackerCommand("right")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // --- Status Pengiriman ---
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.circle,
                  color: isSending ? Colors.orange : cs.primary, size: 10),
              const SizedBox(width: 8),
              Text(isSending ? "Mengirim..." : "Terhubung ke Firebase",
                  style: TextStyle(
                      color: isSending ? Colors.orange : cs.primary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trackerButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: 0.12),
              border: Border.all(
                  color: cs.primary.withValues(alpha: 0.5), width: 1),
            ),
            child: Icon(icon, color: cs.primary, size: 20),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
