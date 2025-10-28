import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../data/models/item.dart';

class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  String _categoryLabel(int id) {
    switch (id) {
      case 1:
        return 'Alam';
      case 2:
        return 'Kuliner';
      case 3:
        return 'Sejarah';
      default:
        return 'Lainnya';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: item.title),
      body: GradientBackground(
        child: ListView(
          children: [
            _heroImage(item),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul + Kategori badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F2FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryBlueDeep.withOpacity(0.2)),
                        ),
                        child: Text(
                          _categoryLabel(item.categoryId),
                          style: const TextStyle(
                              color: Color(0xFF2A6FD4), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Lokasi
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF2A6FD4)),
                      const SizedBox(width: 6),
                      Flexible(child: Text(item.location ?? 'Lokasi: -')),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Info ringkas (tahun & harga)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chipInfo(Icons.calendar_month, item.year ?? 'Tahun/Asal: -'),
                      _chipInfo(Icons.sell_outlined, item.price ?? 'Harga: -'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi singkat (desc) + panjang (longDesc)
                  if ((item.desc).isNotEmpty) Text(item.desc),
                  if ((item.longDesc ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(item.longDesc!),
                  ],

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Simpan ke Favorit (dummy)'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chipInfo(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppTheme.primaryBlueDeep),
      label: Text(text),
      backgroundColor: const Color(0xFFEAF5FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: AppTheme.primaryBlueDeep.withOpacity(0.15)),
    );
  }

  Widget _heroImage(Item item) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: (item.image == null)
          ? _placeholderByCategory(item)
          : Image.asset(
              item.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderByCategory(item),
            ),
    );
  }

  // Placeholder menyesuaikan kategori (alam/kuliner/sejarah)
  Widget _placeholderByCategory(Item item) {
    IconData icon;
    switch (item.categoryId) {
      case 1:
        icon = Icons.park_rounded; // alam
        break;
      case 2:
        icon = Icons.restaurant_rounded; // kuliner
        break;
      case 3:
        icon = Icons.museum_rounded; // sejarah
        break;
      default:
        icon = Icons.place_rounded;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDeep],
        ),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 64),
      ),
    );
  }
}
