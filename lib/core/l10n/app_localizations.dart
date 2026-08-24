import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'MaxFashion'**
  String get appName;

  /// The name of the current language in its own script
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// The name of the English language in its own script
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguageName;

  /// The name of the Arabic language in its own script
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguageName;

  /// Title for the sign-in required dialog
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get signInRequired;

  /// Default message for the sign-in required dialog
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access this feature.'**
  String get signInRequiredMessage;

  /// Label for the sign-in button
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// Label for the create account button
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccount;

  /// Label for cancel buttons
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// Label for the dismiss/acknowledge button
  ///
  /// In en, this message translates to:
  /// **'GOT IT'**
  String get gotIt;

  /// Label for confirm buttons
  ///
  /// In en, this message translates to:
  /// **'CONFIRM'**
  String get confirm;

  /// Validation message when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// Validation message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get emailInvalid;

  /// Validation message when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// Validation message when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Generic validation message when a required field is empty
  ///
  /// In en, this message translates to:
  /// **'Please fill the field'**
  String get fieldRequired;

  /// Placeholder text in the search bar
  ///
  /// In en, this message translates to:
  /// **'Search....'**
  String get searchHint;

  /// Default error message for unexpected failures
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// Generic error when content fails to load
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load content. Please try again.'**
  String get loadFailed;

  /// Generic error when an action fails to complete
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the action. Please try again.'**
  String get operationFailed;

  /// Text showing when a user became a member
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// Generic fallback label for unknown card brands
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get cardBrand;

  /// Title text on the login page
  ///
  /// In en, this message translates to:
  /// **'Welcome\nBack'**
  String get welcomeBack;

  /// Subtitle text on the login page
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Hint text for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Hint text for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Link text to navigate to forgot password page
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Label for the remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// Separator text between login options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Label for the sign-up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Title text on the signup page
  ///
  /// In en, this message translates to:
  /// **'Create\nAccount'**
  String get createAccountTitle;

  /// Subtitle text on the signup page
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// Hint text for full name input field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Hint text for phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Hint text for confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Validation message when name field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// Validation message when phone field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// Validation message when phone number is not 11 digits
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 digits'**
  String get phoneMustBe11Digits;

  /// Validation message when phone format is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Egyptian phone number'**
  String get enterValidEgyptianPhone;

  /// Validation message when confirm password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// Validation message when passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Info message shown after signup with email confirmation
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent! Please check your inbox and verify your email, then login.'**
  String get emailConfirmationSent;

  /// Title text on the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Forgot\nPassword'**
  String get forgotPasswordTitle;

  /// Subtitle text on the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification code'**
  String get enterEmailForCode;

  /// Info message shown when verification code is sent
  ///
  /// In en, this message translates to:
  /// **'Verification code sent! Check your inbox.'**
  String get verificationCodeSent;

  /// Button text to enter verification code
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// Button text to send verification code
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// Title text on the verify code page
  ///
  /// In en, this message translates to:
  /// **'Verify\nCode'**
  String get verifyCodeTitle;

  /// Subtitle text on the verify code page
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String enterCodeSentTo(String email);

  /// Validation message when OTP code is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please enter the full 6-digit code'**
  String get pleaseEnterFullCode;

  /// Button text to verify the code
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// Link text to resend verification code
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Countdown text before resend is available
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(String seconds);

  /// Title text on the reset password page
  ///
  /// In en, this message translates to:
  /// **'New\nPassword'**
  String get newPasswordTitle;

  /// Subtitle text on the reset password page
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account'**
  String get createNewPasswordSubtitle;

  /// Success message after password is updated
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully! You can now login with your new password.'**
  String get passwordUpdatedSuccess;

  /// Button text to navigate to login after password reset
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// Hint text for new password input field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Button text to update the password
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// Error when trying to sign up with an existing email
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get accountAlreadyExists;

  /// Error when login credentials are wrong
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get incorrectEmailOrPassword;

  /// Error when verification code is invalid or expired
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code. Please try again.'**
  String get invalidOrExpiredCode;

  /// Error when network is unavailable
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternetConnection;

  /// Error when connection times out
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get connectionTimedOut;

  /// Error when code resend is rate-limited
  ///
  /// In en, this message translates to:
  /// **'Please wait before requesting another code.'**
  String get pleaseWaitBeforeResend;

  /// Error when user profile fails to load
  ///
  /// In en, this message translates to:
  /// **'Could not load profile. Please try again.'**
  String get couldNotLoadProfile;

  /// Button text for users who already have an account
  ///
  /// In en, this message translates to:
  /// **'Already have account'**
  String get alreadyHaveAccount;

  /// Link text to continue as a guest user
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Section title on the home page
  ///
  /// In en, this message translates to:
  /// **'Explore Collections'**
  String get exploreCollections;

  /// Label for the 'All' category filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// Empty state message when no products are available
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// Label for the about section link
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for the contact section link
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Label for the blog section link
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// Label for the menu section or bottom nav item
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Label for the categories section
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Title for the shop-by section in the menu
  ///
  /// In en, this message translates to:
  /// **'Shop By'**
  String get shopBy;

  /// Title for the all-categories page
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// Empty state message when no categories are available
  ///
  /// In en, this message translates to:
  /// **'No Categories Found'**
  String get noCategoriesFound;

  /// Text showing the number of categories
  ///
  /// In en, this message translates to:
  /// **'{count} categories'**
  String categoriesCount(String count);

  /// Label for the new arrivals shop-by item
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get newArrivals;

  /// Label for the trending-now shop-by item
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// Label for the best-sellers shop-by item
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get bestSellers;

  /// Label for the online-exclusive shop-by item
  ///
  /// In en, this message translates to:
  /// **'Online Exclusive'**
  String get onlineExclusive;

  /// Link text to see more items
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// Placeholder text in the menu search bar
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategoriesHint;

  /// Label for the size selector section
  ///
  /// In en, this message translates to:
  /// **'SIZE'**
  String get size;

  /// Label showing the selected size in cart/wishlist items
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String sizeLabel(String size);

  /// Label for the estimated total price
  ///
  /// In en, this message translates to:
  /// **'Est. Total'**
  String get estimatedTotal;

  /// Button text to add item to cart
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// Dialog message prompting guest to sign in to add items
  ///
  /// In en, this message translates to:
  /// **'Sign in to add items to your bag.'**
  String get signInToAddToBag;

  /// Text showing the number of items
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(String count);

  /// Empty state message when no items exist in a category
  ///
  /// In en, this message translates to:
  /// **'No items in {category} yet'**
  String noItemsInCategory(String category);

  /// Formatted price value with dollar sign
  ///
  /// In en, this message translates to:
  /// **'\${price}'**
  String priceValue(String price);

  /// Placeholder text for search on home context
  ///
  /// In en, this message translates to:
  /// **'Search products on home...'**
  String get searchOnHomeHint;

  /// Placeholder text for search in category context
  ///
  /// In en, this message translates to:
  /// **'Search in this category...'**
  String get searchInCategoryHint;

  /// Placeholder text for search in bag context
  ///
  /// In en, this message translates to:
  /// **'Search in your bag...'**
  String get searchInBagHint;

  /// Placeholder text for search in wishlist context
  ///
  /// In en, this message translates to:
  /// **'Search in wishlist...'**
  String get searchInWishlistHint;

  /// Placeholder text for search in orders context
  ///
  /// In en, this message translates to:
  /// **'Search in orders...'**
  String get searchInOrdersHint;

  /// Section header for recent search history
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// Button text to clear all recent searches
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// Section header for suggested search terms
  ///
  /// In en, this message translates to:
  /// **'Suggested for You'**
  String get suggestedForYou;

  /// Section header for popular categories
  ///
  /// In en, this message translates to:
  /// **'Popular Categories'**
  String get popularCategories;

  /// Button text to load more search results
  ///
  /// In en, this message translates to:
  /// **'Load more results'**
  String get loadMoreResults;

  /// Empty state title when no search results match
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// Empty state subtitle suggesting to try a different search
  ///
  /// In en, this message translates to:
  /// **'Try another keyword'**
  String get tryAnotherKeyword;

  /// AppBar title for the cart page
  ///
  /// In en, this message translates to:
  /// **'MY BAG'**
  String get myBag;

  /// Loading state text on the cart page
  ///
  /// In en, this message translates to:
  /// **'Loading your bag...'**
  String get loadingBag;

  /// Label for the cart subtotal
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Label for delivery cost in cart summary
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// Text indicating free delivery
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Button text to proceed to checkout
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Empty state title for the cart page
  ///
  /// In en, this message translates to:
  /// **'Your bag is empty'**
  String get yourBagIsEmpty;

  /// Empty state subtitle for the cart page
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get addItemsToGetStarted;

  /// CTA button text on empty cart page
  ///
  /// In en, this message translates to:
  /// **'START SHOPPING'**
  String get startShopping;

  /// Title on guest cart page prompting sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your bag'**
  String get signInToViewBag;

  /// Subtitle on guest cart/wishlist pages
  ///
  /// In en, this message translates to:
  /// **'Save items and checkout across devices.'**
  String get saveItemsAcrossDevices;

  /// Label for the wishlist page or section
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// SnackBar message when a product is added to cart from wishlist
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart'**
  String productAddedToCart(String productName);

  /// Empty state title for the wishlist page
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// Empty state subtitle for the wishlist page
  ///
  /// In en, this message translates to:
  /// **'Save your favorite products here.'**
  String get saveFavoritesHere;

  /// CTA button text on empty wishlist page
  ///
  /// In en, this message translates to:
  /// **'CONTINUE SHOPPING'**
  String get continueShopping;

  /// Title on guest wishlist page prompting sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your wishlist'**
  String get signInToViewWishlist;

  /// Button text to move a wishlist item to cart
  ///
  /// In en, this message translates to:
  /// **'MOVE TO CART'**
  String get moveToCart;

  /// AppBar title for the all-collections page
  ///
  /// In en, this message translates to:
  /// **'ALL COLLECTIONS'**
  String get allCollections;

  /// Error message when collections fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load collections'**
  String get collectionFailed;

  /// Empty state message when no collections are available
  ///
  /// In en, this message translates to:
  /// **'No Collections Found'**
  String get noCollectionsFound;

  /// Text showing the number of collections
  ///
  /// In en, this message translates to:
  /// **'{count} collections'**
  String collectionsCount(String count);

  /// Empty state message when no items exist in a collection
  ///
  /// In en, this message translates to:
  /// **'No items in {collectionName} yet'**
  String noItemsInCollection(String collectionName);

  /// Label for the home bottom navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNav;

  /// Label for the cart bottom navigation item
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartNav;

  /// Label for the profile bottom navigation item
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get profileNav;

  /// AppBar title for the checkout page
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutPageTitle;

  /// Section header for shipping address on checkout
  ///
  /// In en, this message translates to:
  /// **'SHIPPING ADDRESS'**
  String get shippingAddress;

  /// Button text to add a shipping address
  ///
  /// In en, this message translates to:
  /// **'Add shipping address'**
  String get addShippingAddress;

  /// Section header for shipping method on checkout
  ///
  /// In en, this message translates to:
  /// **'SHIPPING METHOD'**
  String get shippingMethod;

  /// Label for pickup at store shipping method
  ///
  /// In en, this message translates to:
  /// **'Pickup at store'**
  String get pickupAtStore;

  /// Section header for saved payment methods on checkout
  ///
  /// In en, this message translates to:
  /// **'SAVED PAYMENT METHODS'**
  String get savedPaymentMethods;

  /// Button text to add a new payment card
  ///
  /// In en, this message translates to:
  /// **'Add New Card'**
  String get addNewCard;

  /// Section header for payment method on checkout
  ///
  /// In en, this message translates to:
  /// **'PAYMENT METHOD'**
  String get paymentMethodLabel;

  /// Button text to select a payment method
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// Label for the order total on checkout
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// Button text to place the order
  ///
  /// In en, this message translates to:
  /// **'PLACE ORDER'**
  String get placeOrder;

  /// Button text to add a promo code
  ///
  /// In en, this message translates to:
  /// **'ADD Promo Code'**
  String get addPromoCode;

  /// Button text to add a payment card
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCardButton;

  /// Page title when editing an address
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressTitle;

  /// Page title when adding a new address
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddressTitle;

  /// Section header for address label selection
  ///
  /// In en, this message translates to:
  /// **'ADDRESS LABEL'**
  String get addressLabelSection;

  /// Address label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// Address label for work
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workLabel;

  /// Address label for other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// Hint text for street address input
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddressHint;

  /// Hint text for apartment input
  ///
  /// In en, this message translates to:
  /// **'Apartment, Suite, etc. (optional)'**
  String get apartmentHint;

  /// Hint text for city input
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityHint;

  /// Hint text for state input
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateHint;

  /// Hint text for ZIP code input
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCodeHint;

  /// Hint text for country input
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryHint;

  /// Button text to update an address
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// Button text to add an address
  ///
  /// In en, this message translates to:
  /// **'Add now'**
  String get addNowButton;

  /// Title shown after successful payment
  ///
  /// In en, this message translates to:
  /// **'PAYMENT SUCCESS'**
  String get paymentSuccess;

  /// Message shown after successful payment
  ///
  /// In en, this message translates to:
  /// **'Your payment was successful'**
  String get paymentSuccessMessage;

  /// Label for the payment ID
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get paymentIdLabel;

  /// Label for rating section on success dialog
  ///
  /// In en, this message translates to:
  /// **'Rate your purchase'**
  String get ratePurchase;

  /// Button text to submit rating
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submit;

  /// Title shown when item is added to cart
  ///
  /// In en, this message translates to:
  /// **'ADDED TO CART'**
  String get addedToCartTitle;

  /// Message shown when item is added to cart
  ///
  /// In en, this message translates to:
  /// **'Item added to your cart successfully'**
  String get itemAddedMessage;

  /// Message shown after adding item to cart
  ///
  /// In en, this message translates to:
  /// **'You can review your cart or continue shopping.'**
  String get reviewCartOrShop;

  /// Label shown in add-to-cart dialog
  ///
  /// In en, this message translates to:
  /// **'Ready to checkout?'**
  String get readyToCheckout;

  /// Button text to view the cart
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// Button text to continue shopping
  ///
  /// In en, this message translates to:
  /// **'Shop More'**
  String get shopMore;

  /// Title for missing information dialog
  ///
  /// In en, this message translates to:
  /// **'MISSING INFORMATION'**
  String get missingInformation;

  /// Error message when shipping address is missing
  ///
  /// In en, this message translates to:
  /// **'Please add a shipping address'**
  String get addShippingAddressError;

  /// Error message when payment method is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get selectPaymentMethodError;

  /// Error message when order placement fails
  ///
  /// In en, this message translates to:
  /// **'Failed to place order. Please try again.'**
  String get failedPlaceOrder;

  /// Text showing card brand and last 4 digits
  ///
  /// In en, this message translates to:
  /// **'{brand} ending ••••{last4}'**
  String cardEnding(String brand, String last4);

  /// Label showing size and quantity of a cart item
  ///
  /// In en, this message translates to:
  /// **'Size: {size}  Qty: {quantity}'**
  String sizeQtyLabel(String size, String quantity);

  /// Label showing quantity of a cart item
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String qtyLabel(String quantity);

  /// Badge label for default payment method or address
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultBadge;

  /// Dialog message prompting guest to sign in to save favorites
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your favorite products.'**
  String get signInToSaveFavorite;

  /// Rating message for 0 stars
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateExperience;

  /// Rating message for 1 star
  ///
  /// In en, this message translates to:
  /// **'We can do better'**
  String get weCanDoBetter;

  /// Rating message for 2 stars
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback'**
  String get thanksForFeedback;

  /// Rating message for 3 stars
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Rating message for 4 stars
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// Rating message for 5 stars
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get excellent;

  /// Label showing card expiry date
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String expiresLabel(String date);

  /// SnackBar message when a duplicate card is detected
  ///
  /// In en, this message translates to:
  /// **'This card is already saved.'**
  String get cardAlreadySaved;

  /// AppBar title for the orders page
  ///
  /// In en, this message translates to:
  /// **'MY ORDERS'**
  String get myOrders;

  /// Title on guest orders page prompting sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your orders'**
  String get signInToViewOrders;

  /// Subtitle on guest orders page
  ///
  /// In en, this message translates to:
  /// **'Track your purchases and order history.'**
  String get trackPurchases;

  /// Section header for products in order details
  ///
  /// In en, this message translates to:
  /// **'PRODUCTS'**
  String get productsLabel;

  /// Label showing the selected color
  ///
  /// In en, this message translates to:
  /// **'Color: {color}'**
  String colorLabel(String color);

  /// Label showing total price and item count
  ///
  /// In en, this message translates to:
  /// **'Total ({count} items)'**
  String totalItems(String count);

  /// Section header for delivery address in order details
  ///
  /// In en, this message translates to:
  /// **'DELIVERY ADDRESS'**
  String get deliveryAddressLabel;

  /// Empty state title for the orders page
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any orders yet'**
  String get noOrdersYet;

  /// Empty state subtitle for the orders page
  ///
  /// In en, this message translates to:
  /// **'Your completed purchases will appear here.'**
  String get purchasesWillAppear;

  /// Timeline step title for order placed
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// Order status label for processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// Order status label for shipped
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// Order status label for delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// Order status label for cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// Section header for order timeline
  ///
  /// In en, this message translates to:
  /// **'ORDER TIMELINE'**
  String get orderTimeline;

  /// Button text to view order details
  ///
  /// In en, this message translates to:
  /// **'VIEW DETAILS'**
  String get viewDetails;

  /// AppBar title for the profile page
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get youTitle;

  /// Display name for guest users
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// Section header for account menu
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// Menu item to edit profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileMenu;

  /// Menu item for my orders
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrdersMenu;

  /// Menu item for wishlist
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistMenu;

  /// Menu item for addresses
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addressesMenu;

  /// Menu item for payment methods
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethodsMenu;

  /// Menu item for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenu;

  /// Feature name used in sign-in prompt for profile editing
  ///
  /// In en, this message translates to:
  /// **'profile editing'**
  String get featureProfileEditing;

  /// Feature name used in sign-in prompt for orders
  ///
  /// In en, this message translates to:
  /// **'your orders'**
  String get featureYourOrders;

  /// Feature name used in sign-in prompt for wishlist
  ///
  /// In en, this message translates to:
  /// **'your wishlist'**
  String get featureYourWishlist;

  /// Feature name used in sign-in prompt for addresses
  ///
  /// In en, this message translates to:
  /// **'your addresses'**
  String get featureYourAddresses;

  /// Feature name used in sign-in prompt for payment methods
  ///
  /// In en, this message translates to:
  /// **'payment methods'**
  String get featurePaymentMethods;

  /// Message prompting guest to sign in for a feature
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access {feature}.'**
  String pleaseSignInToAccessFeature(String feature);

  /// AppBar title for the edit profile page
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileTitle;

  /// Button text to remove profile photo
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// Section header for personal information in edit profile
  ///
  /// In en, this message translates to:
  /// **'PERSONAL INFORMATION'**
  String get personalInformation;

  /// Hint text for first name input
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// Label for first name input
  ///
  /// In en, this message translates to:
  /// **'FIRST NAME'**
  String get firstNameLabel;

  /// Validation message when first name is empty
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// Validation message when first name exceeds 50 chars
  ///
  /// In en, this message translates to:
  /// **'First name must be 50 characters or less'**
  String get firstNameMaxLength;

  /// Hint text for last name input
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// Label for last name input
  ///
  /// In en, this message translates to:
  /// **'LAST NAME'**
  String get lastNameLabel;

  /// Validation message when last name exceeds 50 chars
  ///
  /// In en, this message translates to:
  /// **'Last name must be 50 characters or less'**
  String get lastNameMaxLength;

  /// Hint text for email address input
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get emailAddressHint;

  /// Label for email input
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// Hint text for phone number input
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// Label for phone number input
  ///
  /// In en, this message translates to:
  /// **'PHONE NUMBER'**
  String get phoneLabel;

  /// Validation message when phone number is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// Hint text for date of birth input
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get dobHint;

  /// Label for date of birth input
  ///
  /// In en, this message translates to:
  /// **'DATE OF BIRTH (OPTIONAL)'**
  String get dobLabel;

  /// Section header for additional info in edit profile
  ///
  /// In en, this message translates to:
  /// **'ADDITIONAL INFO'**
  String get additionalInfo;

  /// Hint text for gender dropdown
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get genderHint;

  /// Label for gender dropdown
  ///
  /// In en, this message translates to:
  /// **'GENDER (OPTIONAL)'**
  String get genderLabel;

  /// Gender option for male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// Gender option for female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// Gender option for other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// Gender option for prefer not to say
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// Hint text for country input in edit profile
  ///
  /// In en, this message translates to:
  /// **'Enter your country'**
  String get countryHintProfile;

  /// Label for country input
  ///
  /// In en, this message translates to:
  /// **'COUNTRY (OPTIONAL)'**
  String get countryLabel;

  /// Validation message when country exceeds 50 chars
  ///
  /// In en, this message translates to:
  /// **'Country must be 50 characters or less'**
  String get countryMaxLength;

  /// Hint text for bio input
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get bioHint;

  /// Label for bio input
  ///
  /// In en, this message translates to:
  /// **'BIO (OPTIONAL)'**
  String get bioLabel;

  /// Validation message when bio exceeds 200 chars
  ///
  /// In en, this message translates to:
  /// **'Bio must be 200 characters or less'**
  String get bioMaxLength;

  /// Title for discard changes confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Discard Changes?'**
  String get discardChanges;

  /// Message for discard changes confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// Button text to discard changes
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardButton;

  /// Button text to save profile changes
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// Title for profile updated success dialog
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profileUpdated;

  /// Message for profile updated success dialog
  ///
  /// In en, this message translates to:
  /// **'Your profile information has been saved successfully.'**
  String get profileUpdatedMessage;

  /// Title for delete card confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Card?'**
  String get deleteCardConfirm;

  /// Warning message for destructive actions
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotUndo;

  /// Button text for delete confirmation
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteButton;

  /// Empty state title for payment methods page
  ///
  /// In en, this message translates to:
  /// **'No saved payment methods.'**
  String get noSavedCards;

  /// Empty state subtitle for payment methods page
  ///
  /// In en, this message translates to:
  /// **'Add your first payment method.'**
  String get addFirstPaymentMethod;

  /// Title for delete address confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Address?'**
  String get deleteAddressConfirm;

  /// Empty state title for addresses page
  ///
  /// In en, this message translates to:
  /// **'No saved addresses.'**
  String get noSavedAddresses;

  /// Empty state subtitle for addresses page
  ///
  /// In en, this message translates to:
  /// **'Add your first delivery address.'**
  String get addFirstAddress;

  /// Button text to edit an item
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// Button label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// Button text to set item as default
  ///
  /// In en, this message translates to:
  /// **'Set Default'**
  String get setDefaultLabel;

  /// AppBar title for the settings page
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// Section header for general settings
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get generalSection;

  /// Settings tile title for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Section header for appearance settings
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearanceSection;

  /// Settings tile title for theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// Theme option for light mode
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Theme option for dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Theme option for system mode
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Section header for notification settings
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notificationsSection;

  /// Settings tile title for push notifications
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Settings tile subtitle for push notifications
  ///
  /// In en, this message translates to:
  /// **'Receive order updates and promotions'**
  String get pushNotificationsSubtitle;

  /// Section header for privacy settings
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get privacySection;

  /// Settings tile title for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Settings tile title for terms and conditions
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// Section header for support settings
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportSection;

  /// Settings tile title for contact support
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Settings tile subtitle for contact support
  ///
  /// In en, this message translates to:
  /// **'Get help with your account'**
  String get contactSupportSubtitle;

  /// Section header for about settings
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// Settings tile title for about app
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Settings tile subtitle showing app version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionLabel;

  /// Settings tile title for sign in (guest state)
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInSection;

  /// Settings tile title for logout (logged-in state)
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutSection;

  /// SnackBar message for placeholder features
  ///
  /// In en, this message translates to:
  /// **'{title} coming soon'**
  String comingSoon(String title);

  /// Description shown in the about dialog
  ///
  /// In en, this message translates to:
  /// **'Your premium fashion destination.'**
  String get aboutDescription;

  /// Copyright notice shown in app footer
  ///
  /// In en, this message translates to:
  /// **'Copyright © OpenUI All Rights Reserved.'**
  String get copyrightText;

  /// Label for business hours that apply every day
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get everyday;

  /// Fallback text when member since date is unavailable
  ///
  /// In en, this message translates to:
  /// **'Member since —'**
  String get memberSinceFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
