// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MaxFashion';

  @override
  String get languageName => 'English';

  @override
  String get englishLanguageName => 'English';

  @override
  String get arabicLanguageName => 'العربية';

  @override
  String get signInRequired => 'Sign in required';

  @override
  String get signInRequiredMessage => 'Please sign in to access this feature.';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get createAccount => 'CREATE ACCOUNT';

  @override
  String get cancel => 'CANCEL';

  @override
  String get gotIt => 'GOT IT';

  @override
  String get confirm => 'CONFIRM';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get fieldRequired => 'Please fill the field';

  @override
  String get searchHint => 'Search....';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get loadFailed => 'Couldn\'t load content. Please try again.';

  @override
  String get operationFailed =>
      'Couldn\'t complete the action. Please try again.';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get cardBrand => 'Card';

  @override
  String get welcomeBack => 'Welcome\nBack';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get or => 'OR';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccountTitle => 'Create\nAccount';

  @override
  String get signUpToGetStarted => 'Sign up to get started';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get phoneMustBe11Digits => 'Phone number must be 11 digits';

  @override
  String get enterValidEgyptianPhone => 'Enter a valid Egyptian phone number';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get emailConfirmationSent =>
      'Confirmation email sent! Please check your inbox and verify your email, then login.';

  @override
  String get forgotPasswordTitle => 'Forgot\nPassword';

  @override
  String get enterEmailForCode =>
      'Enter your email to receive a verification code';

  @override
  String get verificationCodeSent =>
      'Verification code sent! Check your inbox.';

  @override
  String get enterCode => 'Enter Code';

  @override
  String get sendVerificationCode => 'Send Verification Code';

  @override
  String get verifyCodeTitle => 'Verify\nCode';

  @override
  String enterCodeSentTo(String email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get pleaseEnterFullCode => 'Please enter the full 6-digit code';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(String seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get newPasswordTitle => 'New\nPassword';

  @override
  String get createNewPasswordSubtitle =>
      'Create a new password for your account';

  @override
  String get passwordUpdatedSuccess =>
      'Password updated successfully! You can now login with your new password.';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get newPassword => 'New Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get accountAlreadyExists =>
      'An account with this email already exists.';

  @override
  String get incorrectEmailOrPassword => 'Incorrect email or password.';

  @override
  String get invalidOrExpiredCode =>
      'Invalid or expired code. Please try again.';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network.';

  @override
  String get connectionTimedOut => 'Connection timed out. Please try again.';

  @override
  String get pleaseWaitBeforeResend =>
      'Please wait before requesting another code.';

  @override
  String get couldNotLoadProfile => 'Could not load profile. Please try again.';

  @override
  String get alreadyHaveAccount => 'Already have account';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get exploreCollections => 'Explore Collections';

  @override
  String get allCategory => 'All';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get about => 'About';

  @override
  String get contact => 'Contact';

  @override
  String get blog => 'Blog';

  @override
  String get menu => 'Menu';

  @override
  String get categories => 'Categories';

  @override
  String get shopBy => 'Shop By';

  @override
  String get allCategories => 'All Categories';

  @override
  String get noCategoriesFound => 'No Categories Found';

  @override
  String categoriesCount(String count) {
    return '$count categories';
  }

  @override
  String get newArrivals => 'New Arrivals';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get bestSellers => 'Best Sellers';

  @override
  String get onlineExclusive => 'Online Exclusive';

  @override
  String get seeMore => 'See More';

  @override
  String get searchCategoriesHint => 'Search categories...';

  @override
  String get size => 'SIZE';

  @override
  String sizeLabel(String size) {
    return 'Size: $size';
  }

  @override
  String get estimatedTotal => 'Est. Total';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get signInToAddToBag => 'Sign in to add items to your bag.';

  @override
  String itemsCount(String count) {
    return '$count items';
  }

  @override
  String noItemsInCategory(String category) {
    return 'No items in $category yet';
  }

  @override
  String priceValue(String price) {
    return '\$$price';
  }

  @override
  String get searchOnHomeHint => 'Search products on home...';

  @override
  String get searchInCategoryHint => 'Search in this category...';

  @override
  String get searchInBagHint => 'Search in your bag...';

  @override
  String get searchInWishlistHint => 'Search in wishlist...';

  @override
  String get searchInOrdersHint => 'Search in orders...';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get suggestedForYou => 'Suggested for You';

  @override
  String get popularCategories => 'Popular Categories';

  @override
  String get loadMoreResults => 'Load more results';

  @override
  String get noResultsFound => 'No Results Found';

  @override
  String get tryAnotherKeyword => 'Try another keyword';

  @override
  String get myBag => 'MY BAG';

  @override
  String get loadingBag => 'Loading your bag...';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get delivery => 'Delivery';

  @override
  String get free => 'Free';

  @override
  String get checkout => 'Checkout';

  @override
  String get yourBagIsEmpty => 'Your bag is empty';

  @override
  String get addItemsToGetStarted => 'Add items to get started';

  @override
  String get startShopping => 'START SHOPPING';

  @override
  String get signInToViewBag => 'Sign in to view your bag';

  @override
  String get saveItemsAcrossDevices =>
      'Save items and checkout across devices.';

  @override
  String get wishlist => 'Wishlist';

  @override
  String productAddedToCart(String productName) {
    return '$productName added to cart';
  }

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get saveFavoritesHere => 'Save your favorite products here.';

  @override
  String get continueShopping => 'CONTINUE SHOPPING';

  @override
  String get signInToViewWishlist => 'Sign in to view your wishlist';

  @override
  String get moveToCart => 'MOVE TO CART';

  @override
  String get allCollections => 'ALL COLLECTIONS';

  @override
  String get collectionFailed => 'Failed to load collections';

  @override
  String get noCollectionsFound => 'No Collections Found';

  @override
  String collectionsCount(String count) {
    return '$count collections';
  }

  @override
  String noItemsInCollection(String collectionName) {
    return 'No items in $collectionName yet';
  }

  @override
  String get homeNav => 'Home';

  @override
  String get cartNav => 'Cart';

  @override
  String get profileNav => 'You';

  @override
  String get checkoutPageTitle => 'Checkout';

  @override
  String get shippingAddress => 'SHIPPING ADDRESS';

  @override
  String get addShippingAddress => 'Add shipping address';

  @override
  String get shippingMethod => 'SHIPPING METHOD';

  @override
  String get pickupAtStore => 'Pickup at store';

  @override
  String get savedPaymentMethods => 'SAVED PAYMENT METHODS';

  @override
  String get addNewCard => 'Add New Card';

  @override
  String get paymentMethodLabel => 'PAYMENT METHOD';

  @override
  String get selectPaymentMethod => 'Select payment method';

  @override
  String get totalLabel => 'Total';

  @override
  String get placeOrder => 'PLACE ORDER';

  @override
  String get addPromoCode => 'ADD Promo Code';

  @override
  String get addCardButton => 'Add Card';

  @override
  String get editAddressTitle => 'Edit Address';

  @override
  String get addAddressTitle => 'Add Address';

  @override
  String get addressLabelSection => 'ADDRESS LABEL';

  @override
  String get homeLabel => 'Home';

  @override
  String get workLabel => 'Work';

  @override
  String get otherLabel => 'Other';

  @override
  String get streetAddressHint => 'Street Address';

  @override
  String get apartmentHint => 'Apartment, Suite, etc. (optional)';

  @override
  String get cityHint => 'City';

  @override
  String get stateHint => 'State';

  @override
  String get zipCodeHint => 'ZIP Code';

  @override
  String get countryHint => 'Country';

  @override
  String get updateButton => 'Update';

  @override
  String get addNowButton => 'Add now';

  @override
  String get paymentSuccess => 'PAYMENT SUCCESS';

  @override
  String get paymentSuccessMessage => 'Your payment was successful';

  @override
  String get paymentIdLabel => 'Payment ID';

  @override
  String get ratePurchase => 'Rate your purchase';

  @override
  String get submit => 'SUBMIT';

  @override
  String get addedToCartTitle => 'ADDED TO CART';

  @override
  String get itemAddedMessage => 'Item added to your cart successfully';

  @override
  String get reviewCartOrShop =>
      'You can review your cart or continue shopping.';

  @override
  String get readyToCheckout => 'Ready to checkout?';

  @override
  String get viewCart => 'View Cart';

  @override
  String get shopMore => 'Shop More';

  @override
  String get missingInformation => 'MISSING INFORMATION';

  @override
  String get addShippingAddressError => 'Please add a shipping address';

  @override
  String get selectPaymentMethodError => 'Please select a payment method';

  @override
  String get failedPlaceOrder => 'Failed to place order. Please try again.';

  @override
  String cardEnding(String brand, String last4) {
    return '$brand ending ••••$last4';
  }

  @override
  String sizeQtyLabel(String size, String quantity) {
    return 'Size: $size  Qty: $quantity';
  }

  @override
  String qtyLabel(String quantity) {
    return 'Qty: $quantity';
  }

  @override
  String get defaultBadge => 'DEFAULT';

  @override
  String get signInToSaveFavorite => 'Sign in to save your favorite products.';

  @override
  String get rateExperience => 'Rate your experience';

  @override
  String get weCanDoBetter => 'We can do better';

  @override
  String get thanksForFeedback => 'Thanks for your feedback';

  @override
  String get good => 'Good';

  @override
  String get great => 'Great';

  @override
  String get excellent => 'Excellent!';

  @override
  String expiresLabel(String date) {
    return 'Expires $date';
  }

  @override
  String get cardAlreadySaved => 'This card is already saved.';

  @override
  String get myOrders => 'MY ORDERS';

  @override
  String get signInToViewOrders => 'Sign in to view your orders';

  @override
  String get trackPurchases => 'Track your purchases and order history.';

  @override
  String get productsLabel => 'PRODUCTS';

  @override
  String colorLabel(String color) {
    return 'Color: $color';
  }

  @override
  String totalItems(String count) {
    return 'Total ($count items)';
  }

  @override
  String get deliveryAddressLabel => 'DELIVERY ADDRESS';

  @override
  String get noOrdersYet => 'You haven\'t placed any orders yet';

  @override
  String get purchasesWillAppear =>
      'Your completed purchases will appear here.';

  @override
  String get orderPlaced => 'Order Placed';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get orderTimeline => 'ORDER TIMELINE';

  @override
  String get viewDetails => 'VIEW DETAILS';

  @override
  String get youTitle => 'YOU';

  @override
  String get guestUser => 'Guest User';

  @override
  String get accountSection => 'ACCOUNT';

  @override
  String get editProfileMenu => 'Edit Profile';

  @override
  String get myOrdersMenu => 'My Orders';

  @override
  String get wishlistMenu => 'Wishlist';

  @override
  String get addressesMenu => 'Addresses';

  @override
  String get paymentMethodsMenu => 'Payment Methods';

  @override
  String get settingsMenu => 'Settings';

  @override
  String get featureProfileEditing => 'profile editing';

  @override
  String get featureYourOrders => 'your orders';

  @override
  String get featureYourWishlist => 'your wishlist';

  @override
  String get featureYourAddresses => 'your addresses';

  @override
  String get featurePaymentMethods => 'payment methods';

  @override
  String pleaseSignInToAccessFeature(String feature) {
    return 'Please sign in to access $feature.';
  }

  @override
  String get editProfileTitle => 'EDIT PROFILE';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get personalInformation => 'PERSONAL INFORMATION';

  @override
  String get firstNameHint => 'Enter your first name';

  @override
  String get firstNameLabel => 'FIRST NAME';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get firstNameMaxLength => 'First name must be 50 characters or less';

  @override
  String get lastNameHint => 'Enter your last name';

  @override
  String get lastNameLabel => 'LAST NAME';

  @override
  String get lastNameMaxLength => 'Last name must be 50 characters or less';

  @override
  String get emailAddressHint => 'Your email address';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get phoneLabel => 'PHONE NUMBER';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get dobHint => 'Select your date of birth';

  @override
  String get dobLabel => 'DATE OF BIRTH (OPTIONAL)';

  @override
  String get additionalInfo => 'ADDITIONAL INFO';

  @override
  String get genderHint => 'Select your gender';

  @override
  String get genderLabel => 'GENDER (OPTIONAL)';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get countryHintProfile => 'Enter your country';

  @override
  String get countryLabel => 'COUNTRY (OPTIONAL)';

  @override
  String get countryMaxLength => 'Country must be 50 characters or less';

  @override
  String get bioHint => 'Tell us about yourself';

  @override
  String get bioLabel => 'BIO (OPTIONAL)';

  @override
  String get bioMaxLength => 'Bio must be 200 characters or less';

  @override
  String get discardChanges => 'Discard Changes?';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get discardButton => 'Discard';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get profileUpdated => 'Profile Updated';

  @override
  String get profileUpdatedMessage =>
      'Your profile information has been saved successfully.';

  @override
  String get deleteCardConfirm => 'Delete Card?';

  @override
  String get cannotUndo => 'This action cannot be undone.';

  @override
  String get deleteButton => 'DELETE';

  @override
  String get noSavedCards => 'No saved payment methods.';

  @override
  String get addFirstPaymentMethod => 'Add your first payment method.';

  @override
  String get deleteAddressConfirm => 'Delete Address?';

  @override
  String get noSavedAddresses => 'No saved addresses.';

  @override
  String get addFirstAddress => 'Add your first delivery address.';

  @override
  String get editButton => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get setDefaultLabel => 'Set Default';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get generalSection => 'GENERAL';

  @override
  String get languageLabel => 'Language';

  @override
  String get appearanceSection => 'APPEARANCE';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get notificationsSection => 'NOTIFICATIONS';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsSubtitle =>
      'Receive order updates and promotions';

  @override
  String get privacySection => 'PRIVACY';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get supportSection => 'SUPPORT';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportSubtitle => 'Get help with your account';

  @override
  String get aboutSection => 'ABOUT';

  @override
  String get aboutApp => 'About App';

  @override
  String get versionLabel => 'Version 1.0.0';

  @override
  String get signInSection => 'Sign In';

  @override
  String get logoutSection => 'Logout';

  @override
  String comingSoon(String title) {
    return '$title coming soon';
  }

  @override
  String get aboutDescription => 'Your premium fashion destination.';

  @override
  String get copyrightText => 'Copyright © OpenUI All Rights Reserved.';

  @override
  String get everyday => 'Everyday';

  @override
  String get memberSinceFallback => 'Member since —';
}
