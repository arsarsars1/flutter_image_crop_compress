import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_crop_compress/flutter_image_crop_compress.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? file;
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isProcessing)
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Processing image",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20)
                ],
              ),
            Text(
              file != null ? "Image Picked" : 'Pick image',
            ),
            const SizedBox(height: 20),
            file != null
                ? Image.file(
                    file!,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                  )
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imagePicker(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> imagePicker(BuildContext context,
      {bool isGallery = true}) async {
    isProcessing = true;
    updateState();
    File? fileImage = await pickImage(context, isGallery: isGallery);
    if (fileImage != null && context.mounted) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageCompressCropPage(
              appBar: AppBar(
                key: const Key("appBarCrop"),
                title: const Text("Edit Image"),
              ),
              imageFile: fileImage,
              addAnimation: () => loadingAnimation(context),
              onTap: (File image) {
                file = image;
                updateState();
              },
            ),
          ));
    }
    isProcessing = false;
    updateState();
  }

  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  static Future<File?> pickImage(BuildContext context,
      {bool isGallery = true}) async {
    try {
      File? fileImage;
      final picker = ImagePicker();
      XFile? pickedFile;
      if (isGallery) {
        pickedFile = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
      } else {
        pickedFile = await picker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
      }
      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        fileImage = File(pickedFile.path);
      } else {
        fileImage = null;
      }
      return fileImage;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadingAnimation(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => const CircularProgressIndicator(color: Colors.red));
}
