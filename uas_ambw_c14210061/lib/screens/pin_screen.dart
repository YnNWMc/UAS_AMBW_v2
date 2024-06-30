import 'package:flutter/material.dart';
import '../services/pin_service.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  late PinService _pinService;

  @override
  void initState() {
    super.initState();
    _pinService = PinService();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    if (await _pinService.isFirstTime()) {
      _showCreatePinDialog();
    }
  }

  Future<void> _showCreatePinDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create PIN'),
          content: TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter a PIN'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _pinService.savePin(_pinController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _validatePin() async {
    final pin = await _pinService.getPin();
    if (pin == _pinController.text) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter PIN'),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'PIN'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validatePin,
                child: const Text('Validate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
