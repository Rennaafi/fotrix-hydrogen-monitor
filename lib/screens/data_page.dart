import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../widgets/brand_header.dart';
import '../widgets/line_chart.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  // Data untuk grafik
  final List<double> _ppmSeries = [0];
  final List<double> _timeSeries = [0];

  // State “sensor” & sistem (lokal saja, tidak ke server)
  double _currentPpm = 0;
  bool _isSystemOn = false;
  DateTime? _lastUpdate;

  // Utilitas
  Timer? _timer; // sampling grafik
  late DateTime _startTime;
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Timer untuk update grafik + generate dummy data
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() {
        // Hanya generate data kalau sistem ON
        if (_isSystemOn) {
          // Dummy data: random walk kecil di sekitar nilai sekarang
          final delta = _rand.nextDouble() * 4 - 2; // -2 sampai +2 ppm
          _currentPpm += delta;

          // Clamp range 0–150 ppm
          if (_currentPpm < 0) _currentPpm = 0;
          if (_currentPpm > 150) _currentPpm = 150;

          // Update waktu terakhir "data" diterima
          _lastUpdate = DateTime.now();
        }

        _updateGraphData();
      });
    });
  }

  void _updateGraphData() {
    final elapsedSec =
    DateTime.now().difference(_startTime).inSeconds.toDouble();
    final elapsedMin = elapsedSec / 60;

    _ppmSeries.add(_currentPpm);
    _timeSeries.add(elapsedMin);

    // Batasi panjang data (misal ~2 menit)
    if (_ppmSeries.length > 150) {
      _ppmSeries.removeAt(0);
      _timeSeries.removeAt(0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Anggap "Terhubung" kalau lastUpdate < 10 detik
    final bool connected = _lastUpdate != null &&
        DateTime.now().difference(_lastUpdate!).inSeconds < 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandHeader(title: 'Data Hidrogen'),

          // Kartu Status Sistem
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF121416),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(
                          Icons.power_settings_new_rounded,
                          color: _isSystemOn ? cs.primary : Colors.white60,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status Sistem',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text(
                        _isSystemOn ? 'Sistem Aktif' : 'Sistem Nonaktif',
                        style: TextStyle(
                          color: _isSystemOn
                              ? cs.primary.withValues(alpha: 0.8)
                              : Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isSystemOn,
                    activeThumbColor: cs.primary,
                    activeTrackColor: cs.primary.withValues(alpha: 0.4),
                    onChanged: (v) {
                      setState(() {
                        _isSystemOn = v;

                        if (_isSystemOn) {
                          // Saat baru ON, kasih starting value sedikit
                          if (_currentPpm == 0) {
                            _currentPpm = 20 + _rand.nextDouble() * 10;
                          }
                          _lastUpdate = DateTime.now();
                        } else {
                          // Kalau OFF, biarin lastUpdate berhenti ke-update,
                          // nanti status "Terhubung" akan mati sendiri.
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Informasi Hidrogen
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _isSystemOn ? 1.0 : 0.5,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF121416),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Konsentrasi Hidrogen (H₂)',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pembacaan sensor secara real-time',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white54),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _currentPpm.toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                'ppm',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.25),
                        ),
                        color: cs.primary.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: cs.primary.withValues(alpha: 0.9),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bagian Grafik
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _isSystemOn ? 1.0 : 0.5,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF121416),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        'Data Hidrogen',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.water_drop, color: cs.primary, size: 18),
                    ]),
                    const SizedBox(height: 4),
                    Text(
                      'Perubahan konsentrasi hidrogen terhadap waktu',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.white54),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: LineChart(
                        data: _ppmSeries,
                        time: _timeSeries,
                        lineColor: cs.primary,
                        gridColor: Colors.white12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer status & waktu
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(children: [
              Icon(
                Icons.circle,
                color: connected ? cs.primary : Colors.white54,
                size: 10,
              ),
              const SizedBox(width: 8),
              Text(
                connected ? 'Terhubung' : 'Tidak Terhubung',
                style: TextStyle(
                  color: connected ? cs.primary : Colors.white54,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _fmtLastUpdate(_lastUpdate),
                style: const TextStyle(color: Colors.white70),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  static String _fmtLastUpdate(DateTime? dt) {
    if (dt == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)} ${months[dt.month - 1]} ${dt.year} • '
        '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)} WIB';
  }
}
