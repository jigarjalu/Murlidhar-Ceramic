import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_config.dart';
import '../../data/models/enquiry_model.dart';

/// WhatsApp utility class that builds Gujarati WhatsApp messages
/// and opens WhatsApp directly or via wa.me browser link with snackbar fallback.
class WhatsAppHelper {
  WhatsAppHelper._();

  /// Build single item enquiry message
  static String buildSingleItemMessage({
    required String userName,
    required String itemName,
    required String category,
    required String size,
    required String finish,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('નમસ્તે Murlidhar, હું $userName છું. મને આ આઇટમ વિશે માહિતી જોઈએ છે:');
    buffer.writeln('Item: $itemName');
    buffer.writeln('Category: $category');
    buffer.writeln('Size: $size');
    buffer.writeln('Finish: $finish');
    buffer.write('કૃપા કરીને ભાવ અને ઉપલબ્ધતા જણાવશો.');
    return buffer.toString();
  }

  /// Build multi-item enquiry message from Enquiry List
  static String buildMultiItemMessage({
    required String userName,
    required List<EnquiryItem> items,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('નમસ્તે Murlidhar, હું $userName છું. મને આ આઇટમ વિશે માહિતી જોઈએ છે:');
    for (int i = 0; i < items.length; i++) {
      final it = items[i];
      buffer.writeln('\n[${i + 1}] Item: ${it.productNameGujarati} (${it.productNameEnglish})');
      buffer.writeln('Category: ${it.categoryName}');
      buffer.writeln('Size: ${it.selectedSize}');
      buffer.writeln('Finish: ${it.selectedFinish}');
      if (it.note != null && it.note!.trim().isNotEmpty) {
        buffer.writeln('Note: ${it.note!.trim()}');
      }
    }
    buffer.writeln('\nકૃપા કરીને ભાવ અને ઉપલબ્ધતા જણાવશો.');
    return buffer.toString().trim();
  }

  /// Build general enquiry message
  static String buildGeneralInquiryMessage({
    required String userName,
    required String inquiryDetails,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('નમસ્તે Murlidhar, હું $userName છું.');
    buffer.writeln('મને નીચે મુજબ પૂછપરછ છે:');
    buffer.writeln(inquiryDetails.trim());
    buffer.write('\nકૃપા કરીને માર્ગદર્શન આપશો.');
    return buffer.toString();
  }

  /// Launch WhatsApp with given text, fallback to browser link and snackbar
  static Future<bool> launchWhatsApp({
    required BuildContext context,
    required String message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    const phone = AppConfig.whatsappNumber;

    // Direct whatsapp URL scheme
    final whatsappSchemeUri = Uri.parse('whatsapp://send?phone=$phone&text=$encodedMessage');
    // Web fallback URL
    final webFallbackUri = Uri.parse('https://wa.me/$phone?text=$encodedMessage');

    try {
      if (await canLaunchUrl(whatsappSchemeUri)) {
        return await launchUrl(whatsappSchemeUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webFallbackUri)) {
        final success = await launchUrl(webFallbackUri, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('WhatsApp એપ્લિકેશન ન મળતાં બ્રાઉઝરમાં ખોલવામાં આવ્યું.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return success;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('WhatsApp ખોલી શકાયું નથી. કૃપા કરીને +91 9979079013 પર સીધો સંપર્ક કરો.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return false;
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp ખોલવામાં સમસ્યા આવી.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return false;
    }
  }
}
