import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../models/user.dart' as model;

class AuthController extends GetxController {
  static final instance = Get.find<AuthController>();

  Rx<File?> pickedImage = Rx(null);

  File? get profilePhoto => pickedImage.value;

  void pickImage() async {
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      Get.snackbar(
        'Profile Picture',
        'You have successfully selected your profile picture!',
      );
      pickedImage.value = File(pickedImg.path);
    } else {
      Get.snackbar('Profile Picture', 'No picture selected');
    }
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void registerUser({
    required String name,
    required String email,
    required String password,
    File? image,
  }) async {
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = '';

        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        model.User user = model.User(
          uid: credential.user!.uid,
          name: name,
          email: email,
          profilePhoto: downloadUrl,
        );

        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toMap());
      } else {
        Get.snackbar('Error creating account', 'Please enter all the field');
      }
    } catch (e) {
      Get.snackbar('Error creating account', e.toString());
    }
  }
}
