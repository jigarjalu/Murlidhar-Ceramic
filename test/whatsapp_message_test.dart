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
  });
}
