// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ماكس فاشن';

  @override
  String get languageName => 'العربية';

  @override
  String get englishLanguageName => 'English';

  @override
  String get arabicLanguageName => 'العربية';

  @override
  String get signInRequired => 'تسجيل الدخول مطلوب';

  @override
  String get signInRequiredMessage =>
      'يرجى تسجيل الدخول للوصول إلى هذه الميزة.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get cancel => 'إلغاء';

  @override
  String get gotIt => 'حسناً';

  @override
  String get confirm => 'تأكيد';

  @override
  String get emailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get emailInvalid => 'عنوان بريد إلكتروني غير صالح';

  @override
  String get passwordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get fieldRequired => 'يرجى ملء هذا الحقل';

  @override
  String get searchHint => 'بحث....';

  @override
  String get genericError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get loadFailed => 'تعذّر تحميل المحتوى. يرجى المحاولة مرة أخرى.';

  @override
  String get operationFailed => 'تعذّر إتمام العملية. يرجى المحاولة مرة أخرى.';

  @override
  String memberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get cardBrand => 'بطاقة';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل الدخول للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get or => 'أو';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccountTitle => 'إنشاء\nحساب';

  @override
  String get signUpToGetStarted => 'أنشئ حسابك للبدء';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get pleaseEnterName => 'يرجى إدخال اسمك';

  @override
  String get pleaseEnterPhone => 'يرجى إدخال رقم هاتفك';

  @override
  String get phoneMustBe11Digits => 'يجب أن يكون رقم الهاتف 11 رقم';

  @override
  String get enterValidEgyptianPhone => 'أدخل رقم هاتف مصري صالح';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get emailConfirmationSent =>
      'تم إرسال بريد التأكيد! يرجى التحقق من صندوق الوارد وتأكيد بريدك الإلكتروني، ثم تسجيل الدخول.';

  @override
  String get forgotPasswordTitle => 'نسيت\nكلمة المرور';

  @override
  String get enterEmailForCode => 'أدخل بريدك الإلكتروني لتستلم رمز التحقق';

  @override
  String get verificationCodeSent =>
      'تم إرسال رمز التحقق! تحقق من صندوق الوارد.';

  @override
  String get enterCode => 'إدخال الرمز';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get verifyCodeTitle => 'التحقق\nمن الرمز';

  @override
  String enterCodeSentTo(String email) {
    return 'أدخل الرمز المكون من 6 أرقام المرسل إلى $email';
  }

  @override
  String get pleaseEnterFullCode =>
      'يرجى إدخال الرمز المكون من 6 أرقام بالكامل';

  @override
  String get verifyCode => 'تحقق من الرمز';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendCodeIn(String seconds) {
    return 'إعادة الإرسال خلال $seconds ثانية';
  }

  @override
  String get newPasswordTitle => 'كلمة المرور\nالجديدة';

  @override
  String get createNewPasswordSubtitle => 'أنشئ كلمة مرور جديدة لحسابك';

  @override
  String get passwordUpdatedSuccess =>
      'تم تحديث كلمة المرور بنجاح! يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get updatePassword => 'تحديث كلمة المرور';

  @override
  String get accountAlreadyExists => 'يوجد حساب بالفعل بهذا البريد الإلكتروني.';

  @override
  String get incorrectEmailOrPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get invalidOrExpiredCode =>
      'رمز غير صالح أو منتهي الصلاحية. يرجى المحاولة مرة أخرى.';

  @override
  String get noInternetConnection =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك.';

  @override
  String get connectionTimedOut =>
      'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get pleaseWaitBeforeResend => 'يرجى الانتظار قبل طلب رمز آخر.';

  @override
  String get couldNotLoadProfile =>
      'تعذر تحميل الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get exploreCollections => 'استكشف المجموعات';

  @override
  String get allCategory => 'الكل';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get about => 'حول';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get blog => 'المدونة';

  @override
  String get menu => 'القائمة';

  @override
  String get categories => 'الأقسام';

  @override
  String get shopBy => 'تسوق حسب';

  @override
  String get allCategories => 'جميع الأقسام';

  @override
  String get noCategoriesFound => 'لم يتم العثور على أقسام';

  @override
  String categoriesCount(String count) {
    return '$count أقسام';
  }

  @override
  String get newArrivals => 'وصل حديثاً';

  @override
  String get trendingNow => 'الرائج الآن';

  @override
  String get bestSellers => 'الأكثر مبيعاً';

  @override
  String get onlineExclusive => 'حصري عبر الإنترنت';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get searchCategoriesHint => 'بحث في الأقسام...';

  @override
  String get size => 'المقاس';

  @override
  String sizeLabel(String size) {
    return 'المقاس: $size';
  }

  @override
  String get estimatedTotal => 'الإجمالي التقديري';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get signInToAddToBag => 'سجّل الدخول لإضافة منتجات إلى حقيبتك.';

  @override
  String itemsCount(String count) {
    return '$count منتجات';
  }

  @override
  String noItemsInCategory(String category) {
    return 'لا توجد منتجات في $category بعد';
  }

  @override
  String priceValue(String price) {
    return '\$$price';
  }

  @override
  String get searchOnHomeHint => 'ابحث عن منتجات...';

  @override
  String get searchInCategoryHint => 'بحث في هذا القسم...';

  @override
  String get searchInBagHint => 'بحث في حقيبتك...';

  @override
  String get searchInWishlistHint => 'بحث في قائمة الأمنيات...';

  @override
  String get searchInOrdersHint => 'بحث في الطلبات...';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get suggestedForYou => 'مقترحات لك';

  @override
  String get popularCategories => 'الأقسام الشائعة';

  @override
  String get loadMoreResults => 'تحميل المزيد من النتائج';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get tryAnotherKeyword => 'جرّب كلمة بحث أخرى';

  @override
  String get myBag => 'حقيبتي';

  @override
  String get loadingBag => 'جاري تحميل حقيبتك...';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get delivery => 'التوصيل';

  @override
  String get free => 'مجاني';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get yourBagIsEmpty => 'حقيبتك فارغة';

  @override
  String get addItemsToGetStarted => 'أضف منتجات للبدء';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get signInToViewBag => 'سجّل الدخول لعرض حقيبتك';

  @override
  String get saveItemsAcrossDevices =>
      'احفظ المنتجات وأتمم الشراء عبر الأجهزة.';

  @override
  String get wishlist => 'قائمة الأمنيات';

  @override
  String productAddedToCart(String productName) {
    return 'تمت إضافة $productName إلى السلة';
  }

  @override
  String get wishlistEmpty => 'قائمة أمنياتك فارغة';

  @override
  String get saveFavoritesHere => 'احفظ منتجاتك المفضلة هنا.';

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get signInToViewWishlist => 'سجّل الدخول لعرض قائمة أمنياتك';

  @override
  String get moveToCart => 'نقل إلى السلة';

  @override
  String get allCollections => 'جميع المجموعات';

  @override
  String get collectionFailed => 'فشل تحميل المجموعات';

  @override
  String get noCollectionsFound => 'لم يتم العثور على مجموعات';

  @override
  String collectionsCount(String count) {
    return '$count مجموعات';
  }

  @override
  String noItemsInCollection(String collectionName) {
    return 'لا توجد منتجات في $collectionName بعد';
  }

  @override
  String get homeNav => 'الرئيسية';

  @override
  String get cartNav => 'السلة';

  @override
  String get profileNav => 'أنت';

  @override
  String get checkoutPageTitle => 'إتمام الشراء';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get addShippingAddress => 'إضافة عنوان الشحن';

  @override
  String get shippingMethod => 'طريقة الشحن';

  @override
  String get pickupAtStore => 'الاستلام من المتجر';

  @override
  String get savedPaymentMethods => 'طرق الدفع المحفوظة';

  @override
  String get addNewCard => 'إضافة بطاقة جديدة';

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get addPromoCode => 'إضافة كود خصم';

  @override
  String get addCardButton => 'إضافة بطاقة';

  @override
  String get editAddressTitle => 'تعديل العنوان';

  @override
  String get addAddressTitle => 'إضافة عنوان';

  @override
  String get addressLabelSection => 'تسمية العنوان';

  @override
  String get homeLabel => 'المنزل';

  @override
  String get workLabel => 'العمل';

  @override
  String get otherLabel => 'أخرى';

  @override
  String get streetAddressHint => 'العنوان';

  @override
  String get apartmentHint => 'شقة، جناح، إلخ (اختياري)';

  @override
  String get cityHint => 'المدينة';

  @override
  String get stateHint => 'المنطقة';

  @override
  String get zipCodeHint => 'الرمز البريدي';

  @override
  String get countryHint => 'الدولة';

  @override
  String get updateButton => 'تحديث';

  @override
  String get addNowButton => 'إضافة الآن';

  @override
  String get paymentSuccess => 'تم الدفع بنجاح';

  @override
  String get paymentSuccessMessage => 'تم الدفع بنجاح';

  @override
  String get paymentIdLabel => 'رقم الدفع';

  @override
  String get ratePurchase => 'قيّم مشترياتك';

  @override
  String get submit => 'إرسال';

  @override
  String get addedToCartTitle => 'تمت الإضافة إلى السلة';

  @override
  String get itemAddedMessage => 'تمت إضافة المنتج إلى سلتك بنجاح';

  @override
  String get reviewCartOrShop => 'يمكنك مراجعة سلتك أو متابعة التسوق.';

  @override
  String get readyToCheckout => 'جاهز للشراء؟';

  @override
  String get viewCart => 'عرض السلة';

  @override
  String get shopMore => 'تسوق المزيد';

  @override
  String get missingInformation => 'معلومات ناقصة';

  @override
  String get addShippingAddressError => 'يرجى إضافة عنوان الشحن';

  @override
  String get selectPaymentMethodError => 'يرجى اختيار طريقة الدفع';

  @override
  String get failedPlaceOrder => 'فشل تأكيد الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String cardEnding(String brand, String last4) {
    return '$brand تنتهي بـ ••••$last4';
  }

  @override
  String sizeQtyLabel(String size, String quantity) {
    return 'المقاس: $size  الكمية: $quantity';
  }

  @override
  String qtyLabel(String quantity) {
    return 'الكمية: $quantity';
  }

  @override
  String get defaultBadge => 'الافتراضي';

  @override
  String get signInToSaveFavorite => 'سجّل الدخول لحفظ منتجاتك المفضلة.';

  @override
  String get rateExperience => 'قيّم تجربتك';

  @override
  String get weCanDoBetter => 'يمكننا أن نكون أفضل';

  @override
  String get thanksForFeedback => 'شكراً على ملاحظاتك';

  @override
  String get good => 'جيد';

  @override
  String get great => 'ممتاز';

  @override
  String get excellent => 'رائع!';

  @override
  String expiresLabel(String date) {
    return 'تنتهي صلاحيته $date';
  }

  @override
  String get cardAlreadySaved => 'هذه البطاقة محفوظة بالفعل.';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get signInToViewOrders => 'سجّل الدخول لعرض طلباتك';

  @override
  String get trackPurchases => 'تتبع مشترياتك وسجل طلباتك.';

  @override
  String get productsLabel => 'المنتجات';

  @override
  String colorLabel(String color) {
    return 'اللون: $color';
  }

  @override
  String totalItems(String count) {
    return 'الإجمالي ($count منتجات)';
  }

  @override
  String get deliveryAddressLabel => 'عنوان التوصيل';

  @override
  String get noOrdersYet => 'لم تقم بأي طلبات بعد';

  @override
  String get purchasesWillAppear => 'ستظهر مشترياتك المكتملة هنا.';

  @override
  String get orderPlaced => 'تم الطلب';

  @override
  String get statusProcessing => 'قيد المعالجة';

  @override
  String get statusShipped => 'تم الشحن';

  @override
  String get statusDelivered => 'تم التوصيل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get orderTimeline => 'الجدول الزمني للطلب';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get youTitle => 'أنت';

  @override
  String get guestUser => 'ضيف';

  @override
  String get accountSection => 'الحساب';

  @override
  String get editProfileMenu => 'تعديل الملف الشخصي';

  @override
  String get myOrdersMenu => 'طلباتي';

  @override
  String get wishlistMenu => 'قائمة الأمنيات';

  @override
  String get addressesMenu => 'العناوين';

  @override
  String get paymentMethodsMenu => 'طرق الدفع';

  @override
  String get settingsMenu => 'الإعدادات';

  @override
  String get featureProfileEditing => 'تعديل الملف الشخصي';

  @override
  String get featureYourOrders => 'طلباتك';

  @override
  String get featureYourWishlist => 'قائمة أمنياتك';

  @override
  String get featureYourAddresses => 'عناوينك';

  @override
  String get featurePaymentMethods => 'طرق الدفع';

  @override
  String pleaseSignInToAccessFeature(String feature) {
    return 'يرجى تسجيل الدخول للوصول إلى $feature.';
  }

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get firstNameHint => 'أدخل اسمك الأول';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get firstNameMaxLength => 'يجب أن يكون الاسم الأول 50 حرفاً أو أقل';

  @override
  String get lastNameHint => 'أدخل اسم العائلة';

  @override
  String get lastNameLabel => 'اسم العائلة';

  @override
  String get lastNameMaxLength => 'يجب أن يكون اسم العائلة 50 حرفاً أو أقل';

  @override
  String get emailAddressHint => 'بريدك الإلكتروني';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneHint => 'أدخل رقم هاتفك';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get dobHint => 'اختر تاريخ ميلادك';

  @override
  String get dobLabel => 'تاريخ الميلاد (اختياري)';

  @override
  String get additionalInfo => 'معلومات إضافية';

  @override
  String get genderHint => 'اختر جنسك';

  @override
  String get genderLabel => 'الجنس (اختياري)';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderOther => 'أخرى';

  @override
  String get genderPreferNotToSay => 'أفضّل عدم التوضيح';

  @override
  String get countryHintProfile => 'أدخل بلدك';

  @override
  String get countryLabel => 'الدولة (اختياري)';

  @override
  String get countryMaxLength => 'يجب أن تكون الدولة 50 حرفاً أو أقل';

  @override
  String get bioHint => 'أخبرنا عن نفسك';

  @override
  String get bioLabel => 'السيرة الذاتية (اختياري)';

  @override
  String get bioMaxLength => 'يجب أن تكون السيرة الذاتية 200 حرفاً أو أقل';

  @override
  String get discardChanges => 'تجاهل التغييرات؟';

  @override
  String get unsavedChangesMessage =>
      'لديك تغييرات غير محفوظة. هل أنت متأكد أنك تريد المغادرة؟';

  @override
  String get discardButton => 'تجاهل';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get profileUpdatedMessage => 'تم حفظ معلومات ملفك الشخصي بنجاح.';

  @override
  String get deleteCardConfirm => 'حذف البطاقة؟';

  @override
  String get cannotUndo => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteButton => 'حذف';

  @override
  String get noSavedCards => 'لا توجد طرق دفع محفوظة.';

  @override
  String get addFirstPaymentMethod => 'أضف طريقة الدفع الأولى.';

  @override
  String get deleteAddressConfirm => 'حذف العنوان؟';

  @override
  String get noSavedAddresses => 'لا توجد عناوين محفوظة.';

  @override
  String get addFirstAddress => 'أضف عنوان التوصيل الأول.';

  @override
  String get editButton => 'تعديل';

  @override
  String get deleteLabel => 'حذف';

  @override
  String get setDefaultLabel => 'تعيين كافتراضي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get generalSection => 'عام';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get appearanceSection => 'المظهر';

  @override
  String get themeLabel => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get pushNotifications => 'الإشعارات الفورية';

  @override
  String get pushNotificationsSubtitle => 'استلام تحديثات الطلبات والعروض';

  @override
  String get privacySection => 'الخصوصية';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get supportSection => 'الدعم';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get contactSupportSubtitle => 'الحصول على مساعدة بحسابك';

  @override
  String get aboutSection => 'حول';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get versionLabel => 'الإصدار 1.0.0';

  @override
  String get signInSection => 'تسجيل الدخول';

  @override
  String get logoutSection => 'تسجيل الخروج';

  @override
  String comingSoon(String title) {
    return '$title قريباً';
  }

  @override
  String get aboutDescription => 'وجهتك المتميزة للأزياء.';

  @override
  String get copyrightText => 'حقوق الطبع والنشر © OpenUI. جميع الحقوق محفوظة.';

  @override
  String get everyday => 'يومياً';

  @override
  String get memberSinceFallback => 'عضو منذ —';
}
