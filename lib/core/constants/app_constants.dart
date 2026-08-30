class AppConstants {
  static const String englishLanguageCode = 'en';
  static const String arabicLanguageCode = 'ar';
  static const String fallbackLanguageCode = englishLanguageCode;

  static const String supabaseStorageBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images';

  static const String collectionImagesBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/collection-images';

  static const String fontFamily = 'Tenor_Sans';

  static const String lineImage = 'assets/svgs/line.png';

  // Collection card dimensions (used in .w / .h via flutter_screenutil)
  static const double collectionCardWidth = 230;
  static const double collectionCardHeight = 270;
  static const double collectionImageHeight = 190;
  static const double collectionCardBorderRadius = 12;
  static const double collectionCarouselHeight = 245;

  static const int homeProductsLimit = 12;

  /// Canonical, locale-independent gender values persisted to
  /// Supabase `profiles.gender`. Localized labels live in l10n
  /// (genderMale/genderFemale/genderOther/genderPreferNotToSay) and must
  /// never be stored or used as dropdown item values.
  static const String genderMale = 'Male';
  static const String genderFemale = 'Female';
  static const String genderOther = 'Other';
  static const String genderPreferNotToSay = 'Prefer not to say';

  static const List<String> genderValues = [
    genderMale,
    genderFemale,
    genderOther,
    genderPreferNotToSay,
  ];

  /// Canonical, locale-independent address label values persisted to
  /// Supabase `addresses.label`. Localized labels live in l10n
  /// (homeLabel/workLabel/otherLabel) and must never be stored or used
  /// as selection values.
  static const String addressLabelHome = 'Home';
  static const String addressLabelWork = 'Work';
  static const String addressLabelOther = 'Other';

  static const List<String> addressLabelValues = [
    addressLabelHome,
    addressLabelWork,
    addressLabelOther,
  ];
}
