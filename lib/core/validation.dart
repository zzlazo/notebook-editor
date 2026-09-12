abstract final class TitleValidation {
  static const int minLength = 1;
  static const int maxLength = 50;
  static bool isValid(String title) {
    return title.length >= minLength && title.length <= maxLength;
  }
}

abstract final class BodyValidation {
  static const int minLength = 10;
  static const int maxLength = 2000;
  static bool isValid(String title) {
    return title.length >= minLength && title.length <= maxLength;
  }
}
