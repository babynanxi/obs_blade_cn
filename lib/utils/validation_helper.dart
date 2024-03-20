import '../views/settings/custom_theme/widgets/color_picker/color_slider.dart';

/// Helper class to summarize common validation which are used
/// in several places
class ValidationHelper {
  static String? minLengthValidator(String? text, [int minLength = 1]) =>
      text == null || text.length < minLength
          ? (minLength == 1
              ? '输入不能为空！'
              : '输入至少需要 $minLength 字!')
          : null;

  static String? portValidator(String? text) {
    int? port = int.tryParse(text ?? '');
    if (port != null && port > 0 && port <= 65535) {
      return null;
    }
    return '端口无效';
  }

  static String? ipValidator(String? text) {
    List<String>? ip = text?.split('.');
    if (ip != null &&
        ip.length == 4 &&
        ip.every((part) =>
            part.isNotEmpty &&
            part.length < 4 &&
            int.tryParse(part) != null &&
            int.parse(part) <= 255)) {
      return null;
    }
    return '不是 IP 地址!';
  }

  static String? colorHexValidator(String? text, {bool useAlpha = false}) {
    if (text != null &&
        text.length == (useAlpha ? 8 : 6) &&
        (RegExp(r'^[a-fA-F0-9]+$').allMatches(text).isNotEmpty)) {
      return null;
    }
    return '颜色十六进制代码无效!';
  }

  static String? colorTypeValidator(String? text, ColorType type) {
    if (text != null && text.length <= 3) {
      int? val = int.tryParse(text);
      if (val != null && val >= 0 && val <= type.divisions) {
        return null;
      }
    }
    return '0 - ${type.divisions}';
  }
}
