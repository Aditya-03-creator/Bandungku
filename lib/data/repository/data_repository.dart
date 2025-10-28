import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/category.dart';
import '../models/item.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  final List<Category> _categories = [];
  final List<Item> _items = [];

  Future<void> init() async {
    if (_categories.isNotEmpty || _items.isNotEmpty) return;
    final jsonStr = await rootBundle.loadString('assets/data/dummy.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    final cats = (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
    final its = (data['items'] as List).map((e) => Item.fromJson(e)).toList();

    _categories.addAll(cats);
    _items.addAll(its);
  }

  List<Category> get categories => List.unmodifiable(_categories);
  List<Item> get items => List.unmodifiable(_items);

  List<Item> itemsByCategory(int? categoryId) {
    if (categoryId == null) return items;
    return _items.where((e) => e.categoryId == categoryId).toList();
  }

  void addCategory(String name) {
    final nextId = (_categories.isEmpty)
        ? 1
        : _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
    _categories.add(Category(id: nextId, name: name));
  }

  void addItem({
    required int categoryId,
    required String title,
    required String desc,
    String? image,
  }) {
    final nextId =
        (_items.isEmpty) ? 1 : _items.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;
    _items.add(Item(
      id: nextId,
      categoryId: categoryId,
      title: title,
      desc: desc,
      image: image,
    ));
  }
}
