import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/user_entity.dart';
import 'package:flutter_application_1/Utils/ImageUtils.dart';

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
  String? isLoading;
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
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(150),
                              color: Colors.indigo.shade100),
                          child: InkWell(
                            onTap: () {
                              DialogUtil.showImagePickerDialog(
                                  context,
                                  (File? Image) => setState(() {
                                        pickimage = Image;
                                      }));
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
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget
                                          .updateUserEntity!.profileImage!)),
                                  color: Colors.indigo.shade100),
                              child: InkWell(
                                onTap: () {
                                  DialogUtil.showImagePickerDialog(
                                      context,
                                      (File? Image) => setState(() {
                                            pickimage = Image;
                                          }));
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
                                  DialogUtil.showImagePickerDialog(
                                      context,
                                      (File? Image) => setState(() {
                                            pickimage = Image;
                                          }));
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
                        isLoading != null
                            ? CircularProgressIndicator()
                            : CustomButton(
                                text: widget.updateUserEntity != null
                                    ? "Update"
                                    : "Add",
                                onpressed: () async {
                                  try {
                                    if (pickimage != null) {
                                      await FirebaseStorage.instance
                                          .ref("Profile_Image")
                                          .child(
                                              widget.updateUserEntity!.userId!)
                                          .putFile(pickimage!);
                                      getProfileUrl = await FirebaseStorage
                                          .instance
                                          .ref("Profile_Image")
                                          .child(
                                              widget.updateUserEntity!.userId!)
                                          .getDownloadURL();
                                    }
                                    await UserEntity.doc(
                                            userId: widget
                                                .updateUserEntity!.userId!)
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
}
