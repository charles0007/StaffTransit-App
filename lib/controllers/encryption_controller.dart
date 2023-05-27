import 'package:encrypt/encrypt.dart' as encrytedFnc;

final _ivt = asciiToHexa("w4MES8aqbg-91sM3");
final _keyt = asciiToHexa("CqTl98O6uxGyGNzO");
final _key = encrytedFnc.Key.fromBase16(_keyt);
final _iv = encrytedFnc.IV.fromBase16(_ivt);

String asciiToHexa(String str) {
  final arr1 = [];
  for (var n = 0; n < str.length; n++) {
    final hex = str.codeUnitAt(n).toRadixString(16);
    arr1.add(hex);
  }
  return arr1.join("");
}

String encryptMessage(String message) {
  final encrypter = encrytedFnc.Encrypter(
      encrytedFnc.AES(_key, mode: encrytedFnc.AESMode.cbc));

  final encrypted = encrypter.encrypt(message, iv: _iv);

  String hex = encrypted.bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();

  return hex;
}

String decryptMessage(String encryptedDataStr) {
  final encrypter = encrytedFnc.Encrypter(
      encrytedFnc.AES(_key, mode: encrytedFnc.AESMode.cbc));

  final decrypted = encrypter.decrypt16(encryptedDataStr, iv: _iv);

  return decrypted;
}
