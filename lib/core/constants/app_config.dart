/// Application Identity and Core Configuration.
/// All identity strings, contact numbers, and store metadata are stored ONLY here.
class AppConfig {
  AppConfig._();

  static const String appName = 'Murlidhar Ceramic';
  static const String legalBusinessName =
      'Murlidhar Ceramics & Building Materials';
  static const String tagline = 'Tile Your Dreams...';
  static const String subTagline = 'Premium Tiles & Ceramic Solutions';

  static const String storeAddress =
      "Friend's Square, Cinema Main Road, Manavadar, Gujarat";
  static const String storePhone = '+91 9979079013';
  static const String whatsappNumber = '919979079013';
  static const String whatsappUrl = 'https://wa.me/919979079013';
  static const String googleMapsQuery =
      'https://www.google.com/maps/search/?api=1&query=Murlidhar+Ceramics+Friends+Square+Manavadar';

  static const String logoPath = 'assets/images/logo.png';
  static const String referenceUiPath = 'assets/reference/ui.png';

  // Toggle between Mock data and live Firebase (Phase 6)
  static const bool isMockMode = true;

  // Working Hours
  static const String storeHoursGujarati = 'સોમવાર - શનિવાર: ૮:૩૦ સવારે થી ૮:૩૦ રાત્રે';
  static const String storeHoursEnglish = 'Mon - Sat: 8:30 AM - 8:30 PM';

  // Default Language: Gujarati ('gu'), toggle to English ('en')
  static const String defaultLanguage = 'gu';

  // Category definitions in both Gujarati and English
  static const List<Map<String, String>> categories = [
    {
      'id': 'cat_glazed',
      'gu': 'ગ્લેઝ ટાઈલ્સ',
      'en': 'Glazed Tiles',
      'icon': 'glazed',
    },
    {
      'id': 'cat_vitrified',
      'gu': 'વિટ્રીફાઈડ ટાઈલ્સ',
      'en': 'Vitrified Tiles',
      'icon': 'vitrified',
    },
    {
      'id': 'cat_digital',
      'gu': 'ડિજીટલ ટાઈલ્સ',
      'en': 'Digital Tiles',
      'icon': 'digital',
    },
    {
      'id': 'cat_parking',
      'gu': 'પાર્કિંગ ટાઈલ્સ',
      'en': 'Parking Tiles',
      'icon': 'parking',
    },
    {
      'id': 'cat_grendi',
      'gu': 'ગ્રેન્ડી-પોપરા',
      'en': 'Grendi-Popara',
      'icon': 'grendi',
    },
    {
      'id': 'cat_bath',
      'gu': 'બાથ એસેસરીઝ',
      'en': 'Bath Accessories',
      'icon': 'bath',
    },
    {
      'id': 'cat_chemicals',
      'gu': 'બાંધકામ કેમિકલ્સ',
      'en': 'Construction Chemicals',
      'icon': 'chemicals',
    },
    {
      'id': 'cat_decor',
      'gu': 'હોમ ડેકોર',
      'en': 'Home Decor',
      'icon': 'decor',
    },
    {
      'id': 'cat_colors',
      'gu': 'કલર્સ',
      'en': 'Colors',
      'icon': 'colors',
    },
  ];

  // Price inquiries placeholder texts
  static const String inquiryPriceGujarati = 'ભાવ માટે પૂછપરછ કરો';
  static const String inquiryPriceEnglish = 'Inquiry for best price';

  // Core Value Propositions (for Splash / About)
  static const List<Map<String, String>> valuePropositions = [
    {'gu': 'શ્રેષ્ઠ ગુણવત્તા', 'en': 'Quality', 'key': 'quality'},
    {'gu': 'લાંબા આયુષ્યની ટકાઉપણું', 'en': 'Durability', 'key': 'durability'},
    {'gu': 'આધુનિક ડિઝાઈન', 'en': 'Modern Design', 'key': 'design'},
    {'gu': 'નિષ્ણાત માર્ગદર્શન', 'en': 'Expert Support', 'key': 'support'},
  ];
}
