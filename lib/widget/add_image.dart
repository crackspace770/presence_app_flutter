import 'dart:io';

import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {

  final File? imageFile;
  final void Function()? onTap;

  const AddImage({
    super.key,
    required this.imageFile,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap, // Open camera when icon is tapped
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            shape: BoxShape.rectangle,
          ),
          child: imageFile != null // Show captured image if available
              ? Image.file(
            imageFile!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          )
              : const Icon(
            Icons.camera_alt,
            size: 150,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
