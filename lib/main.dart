import 'package:flutter/material.dart';
import 'package:my_nfc_demo/nfcTest.dart';
import 'package:nfc_manager/nfc_manager.dart';

bool isNfcAvailable = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
  isNfcAvailable = await NfcManager.instance.isAvailable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isNfcAvailable ? const NfcTest() : Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all( 25),
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "*You don't have NFC available on your phone.*",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}
