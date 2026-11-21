/// Product model representing ceramic tiles, bath accessories, colors, etc.
class ProductModel {
  final String id;
  final String categoryId;
  final String nameGujarati;
  final String nameEnglish;
  final List<String> sizes;
  final List<String> finishes;
  final List<String> colors;
  final List<int> colorHexes;
  final List<String> images;
  final String descriptionGujarati;
  final String descriptionEnglish;
  final double rating;
  final int reviewCount;
  final bool showPrice;
  final double? pricePerSqFt;
  final bool isPopular;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.nameGujarati,
    required this.nameEnglish,
    required this.sizes,
    required this.finishes,
    required this.colors,
    this.colorHexes = const [],
    required this.images,
    required this.descriptionGujarati,
    required this.descriptionEnglish,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.showPrice = false,
    this.pricePerSqFt,
    this.isPopular = false,
    this.isFeatured = false,
  });

  String localizedName(String langCode) {
    return langCode == 'gu' ? nameGujarati : nameEnglish;
  }

  String localizedDescription(String langCode) {
    return langCode == 'gu' ? descriptionGujarati : descriptionEnglish;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      categoryId: map['categoryId'] as String? ?? '',
      nameGujarati: map['nameGujarati'] as String? ?? '',
      nameEnglish: map['nameEnglish'] as String? ?? '',
      sizes: List<String>.from(map['sizes'] as List? ?? []),
      finishes: List<String>.from(map['finishes'] as List? ?? []),
      colors: List<String>.from(map['colors'] as List? ?? []),
      colorHexes: List<int>.from(map['colorHexes'] as List? ?? []),
      images: List<String>.from(map['images'] as List? ?? []),
      descriptionGujarati: map['descriptionGujarati'] as String? ?? '',
      descriptionEnglish: map['descriptionEnglish'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 120,
      showPrice: map['showPrice'] as bool? ?? false,
      pricePerSqFt: (map['pricePerSqFt'] as num?)?.toDouble(),
      isPopular: map['isPopular'] as bool? ?? false,
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'nameGujarati': nameGujarati,
      'nameEnglish': nameEnglish,
      'sizes': sizes,
      'finishes': finishes,
      'colors': colors,
      'colorHexes': colorHexes,
      'images': images,
      'descriptionGujarati': descriptionGujarati,
      'descriptionEnglish': descriptionEnglish,
      'rating': rating,
      'reviewCount': reviewCount,
      'showPrice': showPrice,
      'pricePerSqFt': pricePerSqFt,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
    };
  }

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? nameGujarati,
    String? nameEnglish,
    List<String>? sizes,
    List<String>? finishes,
    List<String>? colors,
    List<int>? colorHexes,
    List<String>? images,
    String? descriptionGujarati,
    String? descriptionEnglish,
    double? rating,
    int? reviewCount,
    bool? showPrice,
    double? pricePerSqFt,
    bool? isPopular,
    bool? isFeatured,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      nameGujarati: nameGujarati ?? this.nameGujarati,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      sizes: sizes ?? this.sizes,
      finishes: finishes ?? this.finishes,
      colors: colors ?? this.colors,
      colorHexes: colorHexes ?? this.colorHexes,
      images: images ?? this.images,
      descriptionGujarati: descriptionGujarati ?? this.descriptionGujarati,
      descriptionEnglish: descriptionEnglish ?? this.descriptionEnglish,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      showPrice: showPrice ?? this.showPrice,
      pricePerSqFt: pricePerSqFt ?? this.pricePerSqFt,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
