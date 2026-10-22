import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);
final _quantity = NumberFormat('#,##0.###', 'pt_BR');
final _date = DateFormat('dd/MM/yyyy');

/// 16396 → "R$ 163,96".
String formatMoney(int cents) =>
    _currency.format(cents / 100).replaceAll(' ', ' ');

/// 1.5 → "1,5"; 2.0 → "2".
String formatQuantity(double quantity) => _quantity.format(quantity);

String formatDate(DateTime date) => _date.format(date);

/// "1,5" ou "1.5" → 1.5; vazio → null.
double? parseQuantity(String text) {
  final normalized = text.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  return double.tryParse(normalized);
}

/// "R$ 4,79" → 479; sem dígitos → null.
int? parseMoney(String text) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  return int.parse(digits);
}

String plural(int count, String singular, String pluralForm) =>
    '$count ${count == 1 ? singular : pluralForm}';

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ç': 'c', 'ñ': 'n',
};

/// RN10: minúsculo, sem acento e com espaços simples.
String normalizeName(String name) {
  final lower = name.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    buffer.write(_accents[char] ?? char);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
}

/// Máscara de moeda (RNF03): os dígitos entram pelos centavos.
class MoneyInputFormatter extends TextInputFormatter {
  static const _maxDigits = 9;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > _maxDigits) digits = digits.substring(0, _maxDigits);
    final cents = digits.isEmpty ? 0 : int.parse(digits);
    if (cents == 0) return TextEditingValue.empty;
    final text = formatMoney(cents);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// RN11: quantidade com até 3 casas decimais, nunca negativa.
class QuantityInputFormatter extends TextInputFormatter {
  static final _pattern = RegExp(r'^\d{0,6}([.,]\d{0,3})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => _pattern.hasMatch(newValue.text) ? newValue : oldValue;
}
