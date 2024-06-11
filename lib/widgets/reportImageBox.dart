import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});

  final void Function(List<File>) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final List<File> _storedImages = [];

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImages.add(File(imageFile.path));
    });

    widget.onSelectImage(_storedImages);
  }

  void _removeImage(int index) {
    if (_storedImages.isNotEmpty &&
        index >= 0 &&
        index < _storedImages.length) {
      setState(() {
        _storedImages.removeAt(index);
      });
      widget.onSelectImage(_storedImages);
    } else {
      return;
    }
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.2),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildImageContainer(File image, int index) {
    return GestureDetector(
      child: Container(
        key: ValueKey(image.path),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(image, fit: BoxFit.cover),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _storedImages.isEmpty
        ? _buildAddButton()
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10,
                  children: _storedImages
                      .map((image) => _buildImageContainer(
                          image, _storedImages.indexOf(image)))
                      .toList()
                    ..add(_storedImages.length < 3
                        ? _buildAddButton()
                        : Container()),
                ),
              ),
            ],
          );
  }
}
