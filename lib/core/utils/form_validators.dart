class FormValidators {
  const FormValidators._();

  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? validateEmail(
    String? value, {
    String? emptyError,
    String? invalidError,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyError ?? 'Please enter your email';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return invalidError ?? 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    String? emptyError,
    String? tooShortError,
  }) {
    if (value == null || value.isEmpty) {
      return emptyError ?? 'Please enter your password';
    }
    if (value.length < 6) {
      return tooShortError ?? 'Password must be at least 6 characters';
    }
    return null;
  }
}
