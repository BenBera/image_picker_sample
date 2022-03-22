import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/ $name');
    return File(imagePath).copy(image.path);
  }
    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        // final imageTemporary = File(image.path);
        final imagePermanent = await saveImagePermanently(image.path);

        setState(() {
          this.image = imagePermanent;
        });
      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(children: [
          image != null
              ? Image.file(
                  image!, 
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                )
              : const FlutterLogo(
                  size: 160,
                ),
          const Text("Image picker"),
          const SizedBox(
            height: 16,
          ),
          _buildButton(
              tilte: "Pick Gallery",
              icon: Icons.camera_alt_outlined,
              onCliked: () => pickImage(ImageSource.gallery)),
          _buildButton(
              tilte: "Take a Pickture",
              icon: Icons.camera,
              onCliked: () => pickImage(ImageSource.camera))
        ]),
      ),
    );
  }

  Widget _buildButton(
          {required String tilte,
          required IconData icon,
          required VoidCallback onCliked}) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(46),
            primary: Colors.black,
            onSurface: Colors.white,
            textStyle: TextStyle(fontSize: 20),
          ),
          onPressed: onCliked,
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(tilte)
            ],
          ));

  
}
