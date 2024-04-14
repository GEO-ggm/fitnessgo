// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'success_reg_screen.dart';




class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();

}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  String _firstName = '';
  String _lastName = '';
  DateTime? _birthDate = DateTime.now();
  XFile? _image;

  final ImagePicker _picker = ImagePicker();
   @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

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
  void _showDatePicker (BuildContext context){
    if (Theme.of(context).platform == TargetPlatform.iOS) {
    showCupertinoModalPopup(context: context, builder: (_)=> Container(
      height: 300,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: _birthDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate){
                setState(() => _birthDate = newDate);
              },
            ),
          ),
          CupertinoButton(child: Text('OK'), onPressed: ()=> Navigator.of(context).pop()),
      
        ],
      ),
    ),
    );
    }else {
      // Показать Material DatePicker
    showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate != _birthDate) {
        setState(() {
          _birthDate = pickedDate;
        });
      }
    });
  }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределение пространства между дочерними виджетами
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
            
              GestureDetector(onTap: () => _showDatePicker(context),
              child: AbsorbPointer(child: TextFormField(
                controller: TextEditingController(text: _birthDate != null ? DateFormat('dd.MM.yyyy').format(_birthDate!) : ''),
                decoration: InputDecoration(
                  labelText: 'Дата рождения',
                  hintText: _birthDate == null ? 'Выберите дату' : DateFormat('dd.MM.yyyy').format(_birthDate!),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (_birthDate == null) {
                    return 'Пожалуйста выберите дату рождения.';
                    }
                  return null;
                },
              ),
              ),
              ),
            
            
            SizedBox(height: 110),
            
            Align(
              alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity, // Растягиваем на всю ширину
              child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Здесь код для отправки данных в Firebase
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationCompleteScreen()),
                  );
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
            ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    ),
    );
  }
}
