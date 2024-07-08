import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<File?> getImage(ImageSource source) async {
    final imagepicker = await ImagePicker().pickImage(source: source);
    if (imagepicker != null) {
      return File(imagepicker.path);
    }
    return null;
  }
}

class DialogUtil {
  static void showImagePickerDialog(
      BuildContext context, Function(File?) onImagePicked) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Photo"),
          content: Container(
            height: 110,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    File? image = await ImageUtils.getImage(ImageSource.camera);
                    Navigator.pop(context);
                    onImagePicked(image);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 40,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Camera"), // Replace SmallText with Text
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    File? image =
                        await ImageUtils.getImage(ImageSource.gallery);
                    Navigator.pop(context);
                    onImagePicked(image);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.image,
                        size: 40,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Gallery"), // Replace SmallText with Text
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
