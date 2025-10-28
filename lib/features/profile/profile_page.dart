import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String appTitle = 'BANDUNGKU';
  static const String studentName = 'M. Aditya Dzakiyyul Fikri';
  static const String nim = '230605110190';
  static const String kelas = 'Mobile Programming D';
  static const String logoPath = 'assets/images/logo_fakultas.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Profil'),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _logoCard(),
            const SizedBox(height: 16),
            _infoTile(
              icon: Icons.apps_rounded,
              label: 'Judul Aplikasi',
              value: appTitle,
              iconBg: const Color(0xFFEAF5FF),
            ),
            _infoTile(
              icon: Icons.person_rounded,
              label: 'Nama Lengkap',
              value: studentName,
              iconBg: const Color(0xFFEAF5FF),
            ),
            _infoTile(
              icon: Icons.badge_rounded,
              label: 'NIM',
              value: nim,
              iconBg: const Color(0xFFEAF5FF),
            ),
            _infoTile(
              icon: Icons.school_rounded,
              label: 'Kelas',
              value: kelas,
              iconBg: const Color(0xFFEAF5FF),
            ),
            const SizedBox(height: 12),
            _noteCard(),
          ],
        ),
      ),
    );
  }

  Widget _logoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            logoPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDeep],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  'Logo Fakultas',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBg,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlueDeep),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _noteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.info_outline, color: Color(0xFF2A6FD4)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '#TeknikInformatikaUINMA". ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
