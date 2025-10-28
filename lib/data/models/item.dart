// lib/data/models/item.dart
class Item {
  final int id;
  final int categoryId;
  final String title;
  final String desc;
  final String? image;

  // Detail tambahan (opsional)
  final String? year;
  final String? price;
  final String? location;
  final String? longDesc;

  Item({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.desc,
    this.image,
    this.year,
    this.price,
    this.location,
    this.longDesc,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      categoryId: json['categoryId'] as int,
      title: json['title'] as String,
      desc: json['desc'] as String,
      image: json['image'] as String?,
      year: json['year'] as String?,
      price: json['price'] as String?,
      location: json['location'] as String?,
      longDesc: json['longDesc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'desc': desc,
      'image': image,
      'year': year,
      'price': price,
      'location': location,
      'longDesc': longDesc,
    };
  }
}
