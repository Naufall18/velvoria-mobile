/// Formats numbers as Indonesian Rupiah, e.g. 1234567 → "Rp 1.234.567".
class Currency {
  Currency._();

  static String idr(num value) {
    final whole = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
      buffer.write(whole[i]);
    }
    return 'Rp $buffer';
  }
}
