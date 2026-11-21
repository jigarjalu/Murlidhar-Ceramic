/// Category model representing a tile/ceramic category with dual language support.
class CategoryModel {
  final String id;
  final String nameGujarati;
  final String nameEnglish;
  final String iconName;
  final String imageUrl;
  final int itemCount;

  const CategoryModel({
    required this.id,
    required this.nameGujarati,
    required this.nameEnglish,
    required this.iconName,
    required this.imageUrl,
    this.itemCount = 0,
  });

  String localizedName(String langCode) {
    return langCode == 'gu' ? nameGujarati : nameEnglish;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      nameGujarati: map['nameGujarati'] as String? ?? '',
      nameEnglish: map['nameEnglish'] as String? ?? '',
      iconName: map['iconName'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      itemCount: (map['itemCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameGujarati': nameGujarati,
      'nameEnglish': nameEnglish,
      'iconName': iconName,
      'imageUrl': imageUrl,
      'itemCount': itemCount,
    };
  }
}
