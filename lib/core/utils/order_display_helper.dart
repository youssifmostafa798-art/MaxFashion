class OrderDisplayHelper {
  const OrderDisplayHelper._();

  static String formatOrderId(String rawId) {
    if (rawId.length >= 15) {
      final year = rawId.substring(0, 4);
      final month = rawId.substring(4, 6);
      final day = rawId.substring(6, 8);
      final time = rawId.substring(8, 14);
      return 'ORD-$year$month$day-$time';
    }
    return 'ORD-$rawId';
  }

  static String shortId(String rawId) {
    if (rawId.length >= 6) {
      return rawId.substring(rawId.length - 6).toUpperCase();
    }
    return rawId.toUpperCase();
  }
}
