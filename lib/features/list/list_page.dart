import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/repository/data_repository.dart';
import '../../data/models/item.dart';

class ListPage extends StatefulWidget {
  final int? categoryId; // null = semua
  const ListPage({super.key, this.categoryId});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final repo = DataRepository();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // ✅ Pastikan data JSON diload walaupun datang dari Dashboard
    repo.init().then((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _title();

    return Scaffold(
      appBar: GradientAppBar(
        title: title,
        actions: [
          IconButton(
            onPressed: _loading ? null : () => _showAddItemDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Destinasi',
          ),
        ],
      ),
      body: GradientBackground(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _buildList(),
      ),
    );
  }

  String _title() {
    if (_loading) return 'Memuat...';
    if (widget.categoryId == null) return 'Semua Destinasi';
    final cat = repo.categories.firstWhere(
      (c) => c.id == widget.categoryId,
      orElse: () => (repo.categories.isEmpty)
          ? (throw Exception('Kategori tidak ditemukan'))
          : repo.categories.first,
    );
    return cat.name;
  }

  Widget _buildList() {
    final items = repo.itemsByCategory(widget.categoryId);
    if (items.isEmpty) {
      return const Center(
        child: Text('Belum ada data. Tambahkan destinasi dengan tombol +'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (_, i) => _itemTile(items[i]),
    );
  }

  Widget _itemTile(Item item) {
    return Card(
      child: ListTile(
        leading: _thumb(item),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(item.desc, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.pushNamed(context, RouteNames.detail, arguments: item),
      ),
    );
  }

  Widget _thumb(Item item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 54,
        height: 54,
        child: (item.image == null)
            ? _ph(item.title)
            : Image.asset(
                item.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ph(item.title),
              ),
      ),
    );
  }

  Widget _ph(String title) => Container(
        color: const Color(0xFFE6F2FF),
        child: Center(
          child: Text(
            title.isNotEmpty ? title[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 18, color: Color(0xFF2A6FD4), fontWeight: FontWeight.bold),
          ),
        ),
      );

  Future<void> _showAddItemDialog(BuildContext context) async {
    final titleC = TextEditingController();
    final descC = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Destinasi Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              if (titleC.text.trim().isNotEmpty) {
                repo.addItem(
                  categoryId: widget.categoryId ?? (repo.categories.isNotEmpty ? repo.categories.first.id : 1),
                  title: titleC.text.trim(),
                  desc: descC.text.trim().isEmpty ? '-' : descC.text.trim(),
                );
                Navigator.pop(context);
                setState(() {}); // refresh
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
