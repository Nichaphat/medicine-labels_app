import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech/widget/button_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(TheApp());
}

class TheApp extends StatelessWidget {
   static final String title = 'Medicine Labels';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.teal[600],
          scaffoldBackgroundColor: Colors.white,
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  



  @override
  MyApp createState() => MyApp();
}


class MyApp extends State<MainPage> {
  final FlutterTts flutterTts = FlutterTts();
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(TheApp.title),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/pt2.png",
                  width: 300,
                  height: 300,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '$qrCode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text("START"),
                onPressed: () => _speak(),
              ),
              SizedBox(height: 72),
              ButtonWidget(
                text: 'Start QR Code Scan',
                onClicked: () => scanQRCode(),
              ),
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
  
    Future _speak() async {
      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("th-TH");
      await flutterTts.setPitch(1);
      print(await flutterTts.getVoices);
      await flutterTts.speak("$qrCode");
    }
}

