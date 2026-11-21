enum EnquiryStatus { pending, contacted, closed }

class EnquiryItem {
  final String productId;
  final String productNameGujarati;
  final String productNameEnglish;
  final String categoryName;
  final String selectedSize;
  final String selectedFinish;
  final String imageUrl;
  final String? note;
  final bool showPrice;
  final double? pricePerSqFt;

  const EnquiryItem({
    required this.productId,
    required this.productNameGujarati,
    required this.productNameEnglish,
    required this.categoryName,
    required this.selectedSize,
    required this.selectedFinish,
    required this.imageUrl,
    this.note,
    this.showPrice = false,
    this.pricePerSqFt,
  });

  String localizedProductName(String langCode) {
    return langCode == 'gu' ? productNameGujarati : productNameEnglish;
  }

  factory EnquiryItem.fromMap(Map<String, dynamic> map) {
    return EnquiryItem(
      productId: map['productId'] as String? ?? '',
      productNameGujarati: map['productNameGujarati'] as String? ?? '',
      productNameEnglish: map['productNameEnglish'] as String? ?? '',
      categoryName: map['categoryName'] as String? ?? '',
      selectedSize: map['selectedSize'] as String? ?? '',
      selectedFinish: map['selectedFinish'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      note: map['note'] as String?,
      showPrice: map['showPrice'] as bool? ?? false,
      pricePerSqFt: (map['pricePerSqFt'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productNameGujarati': productNameGujarati,
      'productNameEnglish': productNameEnglish,
      'categoryName': categoryName,
      'selectedSize': selectedSize,
      'selectedFinish': selectedFinish,
      'imageUrl': imageUrl,
      'note': note,
      'showPrice': showPrice,
      'pricePerSqFt': pricePerSqFt,
    };
  }
}

class EnquiryModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<EnquiryItem> items;
  final String generalMessage;
  final EnquiryStatus status;
  final DateTime createdAt;
  final bool isGeneralInquiry;

  const EnquiryModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    this.generalMessage = '',
    this.status = EnquiryStatus.pending,
    required this.createdAt,
    this.isGeneralInquiry = false,
  });

  factory EnquiryModel.fromMap(Map<String, dynamic> map, String id) {
    final statusStr = map['status'] as String? ?? 'pending';
    final status = EnquiryStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => EnquiryStatus.pending,
    );

    final itemsRaw = map['items'] as List? ?? [];
    final items = itemsRaw
        .map((item) => EnquiryItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    return EnquiryModel(
      id: id,
      customerName: map['customerName'] as String? ?? '',
      customerPhone: map['customerPhone'] as String? ?? '',
      items: items,
      generalMessage: map['generalMessage'] as String? ?? '',
      status: status,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isGeneralInquiry: map['isGeneralInquiry'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'items': items.map((e) => e.toMap()).toList(),
      'generalMessage': generalMessage,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'isGeneralInquiry': isGeneralInquiry,
    };
  }

  EnquiryModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    List<EnquiryItem>? items,
    String? generalMessage,
    EnquiryStatus? status,
    DateTime? createdAt,
    bool? isGeneralInquiry,
  }) {
    return EnquiryModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      generalMessage: generalMessage ?? this.generalMessage,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isGeneralInquiry: isGeneralInquiry ?? this.isGeneralInquiry,
    );
  }
}
