import 'package:flutter_test/flutter_test.dart';
import 'package:murlidhar_ceramic/core/utils/whatsapp_helper.dart';
import 'package:murlidhar_ceramic/data/models/enquiry_model.dart';

void main() {
  group('WhatsAppHelper Message Tests', () {
    test('buildSingleItemMessage generates correct Gujarati text format', () {
      final msg = WhatsAppHelper.buildSingleItemMessage(
        userName: 'Ramesh Patel',
        itemName: 'Royal Statuario Glazed',
        category: 'Glazed Tiles',
        size: '600x1200',
        finish: 'High Gloss',
      );

      expect(msg, contains('નમસ્તે Murlidhar, હું Ramesh Patel છું.'));
      expect(msg, contains('Item: Royal Statuario Glazed'));
      expect(msg, contains('Category: Glazed Tiles'));
      expect(msg, contains('Size: 600x1200'));
      expect(msg, contains('Finish: High Gloss'));
      expect(msg, contains('કૃપા કરીને ભાવ અને ઉપલબ્ધતા જણાવશો.'));
    });

    test('buildMultiItemMessage generates formatted list of enquiry items', () {
      final items = [
        const EnquiryItem(
          productId: 'p1',
          productNameGujarati: 'રોયલ સ્ટેચ્યુઆરીયો',
          productNameEnglish: 'Royal Statuario',
          categoryName: 'Glazed Tiles',
          selectedSize: '600x1200',
          selectedFinish: 'Glossy',
          imageUrl: 'url1',
          note: 'Needed for living room',
        ),
        const EnquiryItem(
          productId: 'p2',
          productNameGujarati: 'ગ્રે સ્ટોન વિટ્રીફાઈડ',
          productNameEnglish: 'Grey Stone Vitrified',
          categoryName: 'Vitrified Tiles',
          selectedSize: '800x800',
          selectedFinish: 'Matt',
          imageUrl: 'url2',
        ),
      ];

      final msg = WhatsAppHelper.buildMultiItemMessage(
        userName: 'Priya Shah',
        items: items,
      );

      expect(msg, contains('નમસ્તે Murlidhar, હું Priya Shah છું.'));
      expect(msg, contains('[1] Item: રોયલ સ્ટેચ્યુઆરીયો (Royal Statuario)'));
      expect(msg, contains('Note: Needed for living room'));
      expect(msg, contains('[2] Item: ગ્રે સ્ટોન વિટ્રીફાઈડ (Grey Stone Vitrified)'));
      expect(msg, contains('કૃપા કરીને ભાવ અને ઉપલબ્ધતા જણાવશો.'));
    });

    test('Gujarati message URL encoding preserves characters correctly', () {
      final msg = WhatsAppHelper.buildSingleItemMessage(
        userName: 'રમેશભાઈ',
        itemName: 'પ્રીમિયમ વિટ્રીફાઈડ ટાઈલ',
        category: 'વિટ્રીફાઈડ ટાઈલ્સ',
        size: '800x800',
        finish: 'પોલિશ્ડ',
      );

      final encoded = Uri.encodeComponent(msg);
      final decoded = Uri.decodeComponent(encoded);

      expect(decoded, equals(msg));
      expect(encoded, contains('%E0%AA%A8%E0%AA%AE%E0%AA%B8%E0%AB%8D%E0%AA%A4%E0%AB%87')); // 'નમસ્તે' in UTF-8
    });

    test('buildGeneralInquiryMessage formats free-text enquiry properly', () {
      final msg = WhatsAppHelper.buildGeneralInquiryMessage(
        userName: 'Kiranbhai',
        inquiryDetails: '  Need tiles for 2BHK bungalow  ',
      );

      expect(msg, contains('નમસ્તે Murlidhar, હું Kiranbhai છું.'));
      expect(msg, contains('Need tiles for 2BHK bungalow'));
      expect(msg, contains('કૃપા કરીને માર્ગદર્શન આપશો.'));
    });

    test('buildWhatsAppUri and buildWebFallbackUri encode Gujarati and phone', () {
      final msg = WhatsAppHelper.buildSingleItemMessage(
        userName: 'મહેશ',
        itemName: 'Statuario',
        category: 'Glazed Tiles',
        size: '600x1200',
        finish: 'Glossy',
      );

      final appUri = WhatsAppHelper.buildWhatsAppUri(msg);
      final webUri = WhatsAppHelper.buildWebFallbackUri(msg);

      expect(appUri.scheme, equals('whatsapp'));
      expect(appUri.queryParameters['phone'], equals('919979079013'));
      expect(appUri.queryParameters['text'], equals(msg));

      expect(webUri.scheme, equals('https'));
      expect(webUri.host, equals('wa.me'));
      expect(webUri.path, equals('/919979079013'));
      expect(webUri.queryParameters['text'], equals(msg));
    });
  });
}
