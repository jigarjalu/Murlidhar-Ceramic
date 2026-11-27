import '../models/enquiry_model.dart';

abstract class EnquiryRepository {
  Future<List<EnquiryItem>> getEnquiryCartItems();
  Future<void> addToEnquiryCart(EnquiryItem item);
  Future<void> updateEnquiryCartItemNote(
    String productId,
    String size,
    String finish,
    String? note,
  );
  Future<void> removeFromEnquiryCart(String productId, String size, String finish);
  Future<void> clearEnquiryCart();
  Future<List<EnquiryModel>> getMyEnquiries();
  Future<void> recordSentEnquiry(EnquiryModel enquiry);
  Future<List<EnquiryModel>> getAllEnquiriesForAdmin();
  Future<void> updateEnquiryStatus(String enquiryId, EnquiryStatus status);
}
