import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/user_entity.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  final UserEntity? updateUserEntity;
  const EditScreen({super.key, this.updateUserEntity});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController namecontroller =
      TextEditingController(text: widget.updateUserEntity!.name);

  final _formkey = GlobalKey<FormState>();
  File? pickimage;
  String? getProfileUrl;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            CustomContainer(text: "Edit Profile"),
            const SizedBox(
              height: 40,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  pickimage != null
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                    pickimage!,
                                  ),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.indigo.shade100),
                          child: InkWell(
                            onTap: () {
                              button();
                            },
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : widget.updateUserEntity!.profileImage != null
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                          .updateUserEntity!.profileImage!)),
                                  color: Colors.indigo.shade100),
                              child: InkWell(
                                onTap: () {
                                  button();
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color: Colors.indigo.shade100),
                              child: InkWell(
                                onTap: () {
                                  button();
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: namecontroller,
                          text: "Name",
                          Validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          text: "Update",
                          onpressed: () async {
                            try {
                              if (pickimage != null) {
                                await FirebaseStorage.instance
                                    .ref("Profile_Image")
                                    .child(widget.updateUserEntity!.userId!)
                                    .putFile(pickimage!);
                                getProfileUrl = await FirebaseStorage.instance
                                    .ref("Profile_Image")
                                    .child(widget.updateUserEntity!.userId!)
                                    .getDownloadURL();
                              }
                              await UserEntity.doc(
                                      userId: widget.updateUserEntity!.userId!)
                                  .update({
                                "profileImage": getProfileUrl ??
                                    widget.updateUserEntity!.profileImage,
                                "name": namecontroller.text,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Profile updated Successfully")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  getImage(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(source: source);
    setState(() {
      if (imagePicker != null) {
        pickimage = File(imagePicker.path);
      }
    });
  }

  button() {
    return showDialog(
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
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.camera,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SmallText(text: "Camera")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SmallText(text: "Gallery"),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
