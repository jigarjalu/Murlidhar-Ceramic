import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enquiry_model.dart';
import 'enquiry_repository.dart';

class MockEnquiryRepository implements EnquiryRepository {
  static const String _prefCartKey = 'mc_enquiry_cart_items';
  static const String _prefMyEnquiriesKey = 'mc_my_sent_enquiries';

  final List<EnquiryModel> _adminEnquiries = [
    EnquiryModel(
      id: 'enq_101',
      customerName: 'Rahul Patel',
      customerPhone: '+91 9876543210',
      items: const [
        EnquiryItem(
          productId: 'prod_vt_01',
          productNameGujarati: 'પ્રીમિયમ વિટ્રીફાઈડ ટાઈલ',
          productNameEnglish: 'Premium Vitrified Tile',
          categoryName: 'Vitrified Tiles',
          selectedSize: '800x800',
          selectedFinish: 'Glossy',
          imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&q=80',
        ),
      ],
      generalMessage: 'Looking for vitrified tiles for 3BHK flat flooring.',
      status: EnquiryStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    EnquiryModel(
      id: 'enq_102',
      customerName: 'Priya Shah',
      customerPhone: '+91 9822012345',
      items: const [
        EnquiryItem(
          productId: 'prod_gl_01',
          productNameGujarati: 'રોયલ સ્ટેચ્યુઆરીયો ગ્લેઝ',
          productNameEnglish: 'Royal Statuario Glazed',
          categoryName: 'Glazed Tiles',
          selectedSize: '600x1200',
          selectedFinish: 'High Gloss',
          imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&q=80',
        ),
      ],
      generalMessage: 'Need best price for 1200 sq ft.',
      status: EnquiryStatus.contacted,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    EnquiryModel(
      id: 'enq_103',
      customerName: 'Meet Desai',
      customerPhone: '+91 9909099090',
      items: const [
        EnquiryItem(
          productId: 'prod_pk_01',
          productNameGujarati: 'હેવી ડ્યુટી ચેકર્ડ પાર્કિંગ',
          productNameEnglish: 'Heavy Duty Checkered Parking',
          categoryName: 'Parking Tiles',
          selectedSize: '400x400',
          selectedFinish: 'Anti-Skid Matt',
          imageUrl: 'https://images.unsplash.com/photo-1590381105924-c72589b9ef3f?w=500&q=80',
        ),
      ],
      generalMessage: 'Interested for hospital parking area.',
      status: EnquiryStatus.closed,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Future<List<EnquiryItem>> getEnquiryCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefCartKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => EnquiryItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addToEnquiryCart(EnquiryItem item) async {
    final items = await getEnquiryCartItems();
    final existingIndex = items.indexWhere(
      (e) =>
          e.productId == item.productId &&
          e.selectedSize == item.selectedSize &&
          e.selectedFinish == item.selectedFinish,
    );

    if (existingIndex == -1) {
      items.add(item);
      await _saveCart(items);
    }
  }

  @override
  Future<void> updateEnquiryCartItemNote(
    String productId,
    String size,
    String finish,
    String? note,
  ) async {
    final items = await getEnquiryCartItems();
    final idx = items.indexWhere(
      (e) =>
          e.productId == productId &&
          e.selectedSize == size &&
          e.selectedFinish == finish,
    );
    if (idx != -1) {
      final cleanNote = (note != null && note.trim().isNotEmpty) ? note.trim() : null;
      items[idx] = EnquiryItem(
        productId: items[idx].productId,
        productNameGujarati: items[idx].productNameGujarati,
        productNameEnglish: items[idx].productNameEnglish,
        categoryName: items[idx].categoryName,
        selectedSize: items[idx].selectedSize,
        selectedFinish: items[idx].selectedFinish,
        imageUrl: items[idx].imageUrl,
        note: cleanNote,
        showPrice: items[idx].showPrice,
        pricePerSqFt: items[idx].pricePerSqFt,
      );
      await _saveCart(items);
    }
  }

  @override
  Future<void> removeFromEnquiryCart(
    String productId,
    String size,
    String finish,
  ) async {
    final items = await getEnquiryCartItems();
    items.removeWhere(
      (e) =>
          e.productId == productId &&
          e.selectedSize == size &&
          e.selectedFinish == finish,
    );
    await _saveCart(items);
  }

  @override
  Future<void> clearEnquiryCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefCartKey);
  }

  @override
  Future<List<EnquiryModel>> getMyEnquiries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefMyEnquiriesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => EnquiryModel.fromMap(Map<String, dynamic>.from(e as Map), e['id'] as String? ?? ''))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> recordSentEnquiry(EnquiryModel enquiry) async {
    final enquiries = await getMyEnquiries();
    enquiries.insert(0, enquiry);
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(enquiries.map((e) {
      final map = e.toMap();
      map['id'] = e.id;
      return map;
    }).toList());
    await prefs.setString(_prefMyEnquiriesKey, encoded);

    // Also add to admin list for mock
    _adminEnquiries.insert(0, enquiry);
  }

  @override
  Future<List<EnquiryModel>> getAllEnquiriesForAdmin() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_adminEnquiries);
  }

  @override
  Future<void> updateEnquiryStatus(String enquiryId, EnquiryStatus status) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final idx = _adminEnquiries.indexWhere((e) => e.id == enquiryId);
    if (idx != -1) {
      _adminEnquiries[idx] = _adminEnquiries[idx].copyWith(status: status);
    }
  }

  Future<void> _saveCart(List<EnquiryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_prefCartKey, encoded);
  }
}
