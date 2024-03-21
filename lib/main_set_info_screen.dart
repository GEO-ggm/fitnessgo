// ignore_for_file: prefer_const_constructors

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';



class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  // Метод для выбора фотографии
  Future<void> _pickAndCropImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          
        ],
        uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Редактирование',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Редактирование',
        ),
        ],
    );
    if (croppedImage != null) {
      setState(() {
        _image = XFile(croppedImage.path);
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Немного о себе'),
        
      ),
      body: Form(
        
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/back.png"), 
          fit:BoxFit.cover,)
          ),
          
          padding: EdgeInsets.all(16.0),
          child: Column(
          children: <Widget>[
            
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickAndCropImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
                child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Имя'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста введите свое имя.';
                }
                return null;
              },
              onSaved: (value) => _firstName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Фамилия'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста введите свою фамилию.';
                }
                return null;
              },
              onSaved: (value) => _lastName = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Здесь код для отправки данных в Firebase
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 98, 77),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300, fontSize: 22),
                ),
              child: Text('Продолжить'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
