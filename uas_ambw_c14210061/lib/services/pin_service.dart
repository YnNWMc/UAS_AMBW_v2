import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const _pinKey = 'pin_key';
  static const _pinSetKey = 'pin_set'; // Define _pinSetKey

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString(_pinKey);
    return storedPin != null;
  }

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_pinKey) || !(prefs.getBool(_pinSetKey) ?? false);
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
    await prefs.setBool(_pinSetKey, true);
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  Future<void> deletePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
    await prefs.setBool(
        _pinSetKey, false); // Set pin_set to false after deleting PIN
  }
}
