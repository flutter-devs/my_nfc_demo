import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:convert' show utf8;

class NfcTest extends StatelessWidget {
  const NfcTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          height: 100,
          width: double.infinity,
          child: Column(
            children: [
              TextButton(
                onPressed: () =>
                    NfcManager.instance.startSession(onDiscovered: (tag) async {
                  Ndef? ndef = Ndef.from(tag);

                  NdefMessage message = NdefMessage([
                    NdefRecord.createExternal('android.com', 'pkg',
                        Uint8List.fromList('com.example'.codeUnits))
                  ]);

                  try {
                    await ndef!.write(message);
                    NfcManager.instance.stopSession();
                    print("Counter witten a tag");
                    // _alert('Counter written to tag');

                    return;
                  } catch (e) {
                    print('error $e');
                    return;
                  }
                }),
                child: const Text('Write NFC'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () =>
                    NfcManager.instance.startSession(onDiscovered: (tag) async {
                  Ndef? ndef = Ndef.from(tag);

                  try {
                    if (ndef?.cachedMessage != null) {
                      var ndefMessage = ndef?.cachedMessage!;
                      if (ndefMessage!.records.isNotEmpty &&
                          ndefMessage.records.first.typeNameFormat ==
                              NdefTypeNameFormat.nfcWellknown) {
                        final wellKnownRecord = ndefMessage.records.first;

                        if (wellKnownRecord.payload.first == 0x02) {
                          final languageCodeAndContentBytes =
                          wellKnownRecord.payload.skip(1).toList();
                          final languageCodeAndContentText =
                          utf8.decode(languageCodeAndContentBytes);
                          final payload = languageCodeAndContentText.substring(
                              2);
                          final storedCounters = int.tryParse(payload);
                          if (storedCounters != null) {
                            print("Success!");
                            print('Counter restored from tag');
                          }
                        }
                      }
                    }
                    if (Platform.isIOS) {
                      NfcManager.instance.stopSession();
                    }
                  } catch(e) {
                    print("Tag isn't valid");
                  }
                    }),
                child: const Text('Read from NFC'),
              ),
            ],
          ),
        ),
      ),
    );
  }


// void _alert(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(
//         message,
//       ),
//       duration: const Duration(
//         seconds: 2,
//       ),
//     ),
//   );
// }

}
