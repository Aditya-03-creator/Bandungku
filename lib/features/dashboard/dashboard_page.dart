import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Dashboard'),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _heroHeader(),
            const SizedBox(height: 16),
            _description(),
            const SizedBox(height: 16),
            _menuGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _heroHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDeep],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.location_city_rounded, color: Colors.white, size: 54),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BANDUNGKU',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('Temukan destinasi alam, kuliner, dan sejarah di Kota Bandung.',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _description() {
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
                'Aplikasi ini sedikit menjelaskan beberapa destinasi wisata mulai dari alam '
                'sampai makanan yang ada di Kota Bandung.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // layar kecil dapat kartu sedikit lebih tinggi
    final ratio = width < 360 ? 0.80 : 0.90;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: ratio, // ✅ tambah tinggi kartu → hilang overflow
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _glassCard(
          context,
          title: 'Kategori',
          subtitle: 'Lihat destinasi',
          icon: Icons.category_rounded,
          onTap: () => Navigator.pushNamed(context, RouteNames.list),
        ),
        _glassCard(
          context,
          title: 'Profil',
          subtitle: 'Data mahasiswa',
          icon: Icons.person_rounded,
          onTap: () => Navigator.pushNamed(context, RouteNames.profile),
        ),
      ],
    );
  }

  // Kartu gaya ringan
  Widget _glassCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0), // 🔧 sedikit lebih kecil dari 16
          child: Column(
            mainAxisSize: MainAxisSize.min,     // 🔧 konten menyesuaikan tinggi
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12), // 🔧 dari 14 → 12
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 30, color: AppTheme.primaryBlueDeep),
              ),
              const SizedBox(height: 10), // 🔧 dari 12 → 10
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // aman di layar kecil
              ),
            ],
          ),
        ),
      ),
    );
  }
}
