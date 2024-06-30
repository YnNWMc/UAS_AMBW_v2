import 'package:flutter/material.dart';
import '../services/pin_service.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({Key? key}) : super(key: key);

  @override
  _ChangePinScreenState createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmNewPinController = TextEditingController();
  final PinService _pinService = PinService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _oldPinController,
              decoration: const InputDecoration(
                labelText: 'Old PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            TextField(
              controller: _newPinController,
              decoration: const InputDecoration(
                labelText: 'New PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            TextField(
              controller: _confirmNewPinController,
              decoration: const InputDecoration(
                labelText: 'Confirm New PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final oldPin = _oldPinController.text;
                final newPin = _newPinController.text;
                final confirmNewPin = _confirmNewPinController.text;

                if (newPin != confirmNewPin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New PINs do not match')),
                  );
                  return;
                }

                final storedPin = await _pinService.getPin();
                if (storedPin == oldPin) {
                  await _pinService.savePin(newPin);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN changed successfully')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid old PIN')),
                  );
                }
              },
              child: const Text('Change PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
