import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/repository/data_repository.dart';
import '../../data/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = DataRepository();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    repo.init().then((_) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Wisata Bandung'),
      body: GradientBackground(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    _heroHeader(context),
                    const SizedBox(height: 8),
                    _sectionTitle('Kategori'),
                    _categoryChips(context, repo.categories),
                    const SizedBox(height: 12),
                    _sectionTitle('Semua Destinasi'),
                    ...repo.items.map(_itemCard).toList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
      floatingActionButton: _fabAdd(context),
    );
  }

  Widget _heroHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDeep],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Jelajah Bandung',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Text('Temukan destinasi alam, kuliner, dan sejarah favoritmu!',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.travel_explore, color: Colors.white, size: 48),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
    );
  }

  Widget _categoryChips(BuildContext context, List<Category> cats) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: cats.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ActionChip(
              label: const Text('Semua'),
              onPressed: () => Navigator.pushNamed(context, RouteNames.list),
            );
          }
          final c = cats[index - 1];
          return ActionChip(
            label: Text(c.name),
            onPressed: () => Navigator.pushNamed(context, RouteNames.list, arguments: c.id),
          );
        },
      ),
    );
  }

  Widget _itemCard(item) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, RouteNames.detail, arguments: item),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _imageThumb(item.image, item.title),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item.desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageThumb(String? path, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 70,
        child: (path == null)
            ? _placeholder(title)
            : Image.asset(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(title),
              ),
      ),
    );
  }

  Widget _placeholder(String title) {
    return Container(
      color: const Color(0xFFE6F2FF),
      child: Center(
        child: Text(
          title.isNotEmpty ? title[0].toUpperCase() : '?',
          style: const TextStyle(fontSize: 28, color: Color(0xFF2A6FD4), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Tombol "+" dengan pilihan tambah kategori/destinasi
  Widget _fabAdd(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, -10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'cat', child: Text('Tambah Kategori')),
        PopupMenuItem(value: 'item', child: Text('Tambah Destinasi')),
      ],
      onSelected: (v) async {
        if (v == 'cat') {
          await _showAddCategoryDialog(context);
        } else {
          await _showAddItemDialog(context);
        }
        setState(() {});
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(radius: 28, child: Icon(Icons.add)),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kategori Baru'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Nama kategori')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                repo.addCategory(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final titleC = TextEditingController();
    final descC = TextEditingController();
    int? selectedCatId = repo.categories.isNotEmpty ? repo.categories.first.id : null;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setSt) {
        return AlertDialog(
          title: const Text('Destinasi Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedCatId,
                  items: repo.categories
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setSt(() => selectedCatId = v),
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                const SizedBox(height: 8),
                TextField(controller: titleC, decoration: const InputDecoration(labelText: 'Judul')),
                const SizedBox(height: 8),
                TextField(controller: descC, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (selectedCatId != null && titleC.text.trim().isNotEmpty) {
                  repo.addItem(
                    categoryId: selectedCatId!,
                    title: titleC.text.trim(),
                    desc: descC.text.trim().isEmpty ? '-' : descC.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      }),
    );
  }
}
