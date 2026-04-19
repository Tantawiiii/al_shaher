/// Converts Arabic-Indic and Persian digits to Western (ASCII) digits.
String westernizeDigits(String input) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  var s = input;
  for (var i = 0; i < 10; i++) {
    s = s.replaceAll(arabic[i], '$i').replaceAll(persian[i], '$i');
  }
  return s;
}
