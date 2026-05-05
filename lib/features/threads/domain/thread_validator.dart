class ThreadValidator {
  static String? validateQuantity(double? value) {
    if (value == null || value <= 0) {
      return 'Quantity must be greater than 0';
    }
    return null;
  }

  static String? validatePrice(double? value) {
    if (value == null || value <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  static bool isValid(double? quantity, double? price) {
    return validateQuantity(quantity) == null && validatePrice(price) == null;
  }
}
