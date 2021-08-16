import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.imagePickerFn})
      : super(key: key);

  final void Function(File pickerImage) imagePickerFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();

  File? _image;

  void _pickImageFunc() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      print(imageFile);
      if (imageFile != null) {
        _image = File(imageFile.path);
      } else {
        print('error');
      }
    });

    widget.imagePickerFn(File(imageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
          onPressed: _pickImageFunc,
          icon: Icon(Icons.image),
          label: Text(
            'Add Image.',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
