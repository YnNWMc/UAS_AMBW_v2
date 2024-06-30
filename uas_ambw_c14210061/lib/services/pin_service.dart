import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pin.dart'; // Adjust the import path as necessary

class PinService {
  static const String _boxName = 'pinBox';
  late Box<Pin> _box;
  late ValueNotifier<bool> _pinSetNotifier;
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await _init();
    }
  }

  Future<void> _init() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Register the PinAdapter if not already registered
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(PinAdapter());
      }

      _box = await Hive.openBox<Pin>(_boxName);
      _pinSetNotifier = ValueNotifier<bool>(_box.isNotEmpty);

      _box.watch().listen((event) {
        _pinSetNotifier.value = _box.isNotEmpty;
      });

      _initialized = true;
      print("PinService initialized successfully.");
    } catch (e) {
      print('Error initializing Hive or opening box: $e');
      rethrow;
    }
  }

  ValueListenable<bool> get pinSetNotifier => _pinSetNotifier;

  Future<bool> isLoggedIn() async {
    await _ensureBoxInitialized();
    return _box.isNotEmpty;
  }

  Future<bool> isFirstTime() async {
    await _ensureBoxInitialized();
    return !_box.isNotEmpty;
  }

  Future<void> savePin(String pin) async {
    await _ensureBoxInitialized();
    try {
      await _box
          .clear(); // Clear existing pin (assuming only one pin is stored)
      await _box.add(Pin(pin));
      print("Pin saved successfully");
    } catch (e, stackTrace) {
      print("Error saving pin: $e");
      print(stackTrace);
    }
  }

  Future<String?> getPin() async {
    await _ensureBoxInitialized();
    if (_box.isNotEmpty) {
      return _box.values.first.pin;
    } else {
      return null;
    }
  }

  Future<void> deletePin() async {
    await _ensureBoxInitialized();
    try {
      await _box.clear(); // Clear existing pin
      print("Pin deleted successfully");
    } catch (e, stackTrace) {
      print("Error deleting pin: $e");
      print(stackTrace);
    }
  }

  Future<void> _ensureBoxInitialized() async {
    if (!_initialized) {
      await _init();
    }
  }

  void dispose() {
    _pinSetNotifier.dispose();
    Hive.close();
  }
}
