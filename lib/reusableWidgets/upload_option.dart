import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

chooseUploadOption(
    {required BuildContext context,
    required Function(ImageSource source) uploadFunction}) {
  showModalBottomSheet(
    context: context,
    builder: ((context) {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => uploadFunction(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent),
              child: const Row(
                children: [
                  Icon(Icons.camera_alt),
                  Text(
                    'Camera',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => uploadFunction(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent),
              child: const Row(
                children: [
                  Icon(
                    Icons.image,
                  ),
                  Text(
                    'Gallery',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}
