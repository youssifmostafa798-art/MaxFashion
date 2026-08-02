class CardUtils {
  const CardUtils._();

  static String detectCardBrand(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanNumber.isEmpty) return 'otherBrand';
    final firstDigit = int.tryParse(cleanNumber[0]) ?? 0;
    if (firstDigit == 4) return 'visa';
    if (firstDigit == 5) return 'mastercard';
    if (firstDigit == 3) return 'americanExpress';
    if (firstDigit == 6) return 'discover';
    return 'otherBrand';
  }

  static String getCardBrandIcon(String brand) {
    switch (brand) {
      case 'visa':
        return 'assets/svgs/visa.svg';
      case 'mastercard':
        return 'assets/svgs/Mastercard.svg';
      default:
        return 'assets/svgs/Mastercard.svg';
    }
  }

  static String getCardBrandName(String brand) {
    switch (brand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      default:
        return 'Card';
    }
  }
}
