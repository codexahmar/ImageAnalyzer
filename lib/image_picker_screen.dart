import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_controller.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePickerController _controller = ImagePickerController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Analyzer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showImageSourceDialog(context),
        child: Icon(Icons.add_a_photo, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: _controller.image == null
                    ? Center(
                        child: Text(
                          'No image selected.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _controller.image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _controller.result.isEmpty
                          ? 'Text from the image will appear here.'
                          : _controller.result,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.image, size: 36, color: Colors.teal),
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.pickImage(ImageSource.gallery);
                    },
                  ),
                  Text('Gallery'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, size: 36, color: Colors.teal),
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.pickImage(ImageSource.camera);
                    },
                  ),
                  Text(
                    'Camera',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
