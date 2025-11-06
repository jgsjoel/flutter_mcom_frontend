import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcommerce/components/CustomButton.dart';
import 'package:mcommerce/components/Snackbar.dart';
import 'package:mcommerce/components/TextFields.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/services/SecureStoreService.dart';
import 'package:mcommerce/state/FirebaseState.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      context.read<FirebaseState>().uploadImage(imageFile);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> loadUserDetails() async {
    Apiservice.getRequest("/account/user", (response) async {
      final respData = response.data;
      _firstNameController.text = respData["firstName"];
      _lastNameController.text = respData["lastName"];
      _emailController.text = respData["email"];
      _mobileController.text = respData["mobile"];

      await loadUserImage(respData["email"]);
    });
  }

  Future<void> loadUserImage(String email) async {
    try {
      String path = "customer/$email";
      String downloadURL = await storage.ref(path).getDownloadURL();
      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Securestoreservice.deleteItem("accessToken");
              Securestoreservice.deleteItem("refreshToken");
              Navigator.pushNamed(context, "/login");
            },
            icon: Icon(Icons.logout)),
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) as ImageProvider
                      : _imageUrl != null
                          ? NetworkImage(_imageUrl!)
                          : null,
                  child: (_imageFile == null && _imageUrl == null)
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _firstNameController,
                hintText: "First Name",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _lastNameController,
                hintText: "Last Name",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                enable: false,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _mobileController,
                hintText: "Mobile",
              ),
              const SizedBox(height: 20),

              CustomLongButton(
                onPressed: () {
                  Apiservice.putRequest(
                      "/account/user",
                      {
                        "firstName": _firstNameController.text,
                        "lastName": _lastNameController.text,
                        "mobile": _mobileController.text,
                      },
                      Options(headers: {
                        Headers.contentTypeHeader: "application/json"
                      }), (response) {
                    showSnackBar("Update Complete", context);
                  });
                },
                backgroundColor: Colors.black,
                text: "Save Details",
              )
            ],
          ),
        ),
      ),
    );
  }
}
