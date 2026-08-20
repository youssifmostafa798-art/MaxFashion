class AppConstants {
  static const String supabaseStorageBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images';

  static const String collectionImagesBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/collection-images';

  static const String fontFamily = 'Tenor_Sans';

  static const String logoPath = 'assets/logo/logo-bg.svg';
  static const String menuIcon = 'assets/svgs/Menu.svg';
  static const String searchIcon = 'assets/svgs/Search.svg';
  static const String shoppingBagIcon = 'assets/svgs/shopping bag.svg';
  static const String lineImage = 'assets/svgs/line.png';
  static const String mastercardIcon = 'assets/svgs/Mastercard.svg';
  static const String promoIcon = 'assets/svgs/promo.svg';
  static const String deliveryIcon = 'assets/svgs/delivery.svg';
  static const String minIcon = 'assets/svgs/min.svg';
  static const String plusIcon = 'assets/svgs/plus.svg';
  static const String doneIcon = 'assets/pop/done.svg';
  static const String emoji1Icon = 'assets/pop/emogi1.svg';
  static const String emoji2Icon = 'assets/pop/emogi2.svg';
  static const String emoji3Icon = 'assets/pop/emogi3.svg';

  // Collection card dimensions (used in .w / .h via flutter_screenutil)
  static const double collectionCardWidth = 230;
  static const double collectionCardHeight = 270;
  static const double collectionImageHeight = 190;
  static const double collectionCardBorderRadius = 12;
  static const double collectionCarouselHeight = 245;

  static const int homeProductsLimit = 12;
}
