import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final teamMembers = [
      _TeamMember(
        name: 'Lady Dayanti',
        role: 'Teknik Kimia',
        imagePath: 'assets/lady1.jpg',
      ),
      _TeamMember(
        name: 'Muhammad Refansa Annaafi',
        role: 'Teknik Elektro',
        imagePath: 'assets/refan1.jpg',
      ),
      _TeamMember(
        name: 'Stanislaus David Aurelian Widodo',
        role: 'Teknik Elektro',
        imagePath: 'assets/david1.jpg',
      ),
      _TeamMember(
        name: 'Muhammad Aksal Hammam',
        role: 'Teknik Mesin',
        imagePath: 'assets/aksal1.jpg',
      ),
      _TeamMember(
        name: 'Cindy Nazwa Putri',
        role: 'Teknik Bioproses',
        imagePath: 'assets/cindy1.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F11),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tentang FOTRIX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: cs.primary,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Project Intro ===
            Center(
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          cs.primary.withOpacity(0.15),
                          cs.primaryContainer.withOpacity(0.05),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/Logonobg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FOTRIX',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'FOTRIX adalah sistem IoT terintegrasi untuk produksi hidrogen dan degradasi mikroplastik langsung dari air laut.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === Mission Section ===
            _SectionHeader(
              icon: Icons.bolt_rounded,
              title: 'Misi Kami',
              color: cs.primary,
            ),
            const SizedBox(height: 10),
            Text(
              'FOTRIX dikembangkan untuk menghadirkan produksi hidrogen yang berkelanjutan langsung dari air laut, sekaligus membantu mengurangi pencemaran mikroplastik. '
                  'Reaktor hibrida elektrokoagulasi–fotokatalisis yang kami rancang menggabungkan inovasi, efisiensi, dan tanggung jawab lingkungan. '
                  'Sistem ini dibangun oleh mahasiswa teknik lintas disiplin dengan visi bersama: menjadikan energi bersih semakin mudah diakses di masa depan.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70, height: 1.6),
            ),

            const SizedBox(height: 32),

            // === User Guide Section ===
            _SectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'Panduan Pengguna',
              color: cs.primary,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF17191C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gunakan panduan singkat ini saat mengoperasikan FOTRIX di laboratorium:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  const _GuideBullet(
                    text:
                    'Pastikan rangkaian reaktor, sensor, dan catu daya sudah terpasang dengan benar dan aman sebelum menyalakan sistem.',
                  ),
                  const _GuideBullet(
                    text:
                    'Buka tab Data untuk memantau konsentrasi hidrogen (ppm) dan status koneksi sistem secara real-time.',
                  ),
                  const _GuideBullet(
                    text:
                    'Gunakan tab Kendali untuk memilih Mode Operasi. Dalam mode Manual, Anda dapat mengatur lampu, pompa, Solar Tracker, dan Konfigurasi Atap secara langsung.',
                  ),
                  const _GuideBullet(
                    text:
                    'Aktifkan Konfigurasi Atap saat Anda ingin panel surya membentuk konfigurasi atap untuk menjaga keamanan dan efisiensi saat kondisi tertentu (misalnya hujan atau selesai digunakan).',
                  ),
                  const _GuideBullet(
                    text:
                    'Setelah percobaan selesai, matikan sistem melalui Panel Kontrol, lalu ikuti prosedur keselamatan  (memutus catu daya dan membersihkan reaktor).',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === Team Section ===
            _SectionHeader(
              icon: Icons.people_alt_rounded,
              title: 'Tim FOTRIX',
              color: cs.primary,
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 400 + index * 120),
                  opacity: 1,
                  child: _TeamCard(member: member),
                );
              },
            ),

            const SizedBox(height: 60),
            Center(
              child: Text(
                '© 2025 Tim FOTRIX • Universitas Indonesia',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _TeamMember {
  final String name;
  final String role;
  final String? imagePath;

  const _TeamMember({
    required this.name,
    required this.role,
    this.imagePath,
  });
}

class _TeamCard extends StatelessWidget {
  final _TeamMember member;

  const _TeamCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 190, // samain tinggi semua card
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF17191C),
            Color(0xFF1D1F22),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: cs.primary.withOpacity(0.15),
            backgroundImage: member.imagePath != null
                ? AssetImage(member.imagePath!)
                : null,
            child: member.imagePath == null
                ? Icon(
              Icons.person_rounded,
              color: cs.primary.withOpacity(0.7),
              size: 34,
            )
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            member.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            member.role,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white60, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _GuideBullet extends StatelessWidget {
  final String text;

  const _GuideBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.white70),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
