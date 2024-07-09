// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/add_data_entity.dart';
import 'package:flutter_application_1/Utils/ImageUtils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddData extends StatefulWidget {
  final AddEntity? updateAddEntity;
  AddData({Key? key, this.updateAddEntity}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController taskNameController;

  @override
  void initState() {
    taskNameController =
        TextEditingController(text: widget.updateAddEntity?.taskname ?? '');
    if (widget.updateAddEntity != null) {
      getUrl = widget.updateAddEntity!.image;
    }
    super.initState();
  }

  bool isLoading = false;
  File? pickImage;
  String? getUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomContainer(text: "Add Data"),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  DialogUtil.showImagePickerDialog(
                      context,
                      (File? Image) => setState(() {
                            pickImage = Image;
                          }));
                },
                child: pickImage != null
                    ? Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.circular(200),
                          image: DecorationImage(
                            image: FileImage(pickImage!.absolute),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : (widget.updateAddEntity?.image != null)
                        ? Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.updateAddEntity!.image!),
                              ),
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 100,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: CustomTextField(
                controller: taskNameController,
                text: "Task Name",
                Validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Task name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              CustomButton(
                text: widget.updateAddEntity != null ? "Update" : "Add",
                onpressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.updateAddEntity == null && pickImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please Select an image")),
                      );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      String addDataID = widget.updateAddEntity?.addId ??
                          AddEntity.collection().doc().id;
                      if (pickImage != null) {
                        await FirebaseStorage.instance
                            .ref("Task Images")
                            .child(addDataID)
                            .putFile(
                              pickImage!,
                              SettableMetadata(contentType: "jpeg"),
                            );
                        getUrl = await FirebaseStorage.instance
                            .ref("Task Images")
                            .child(addDataID)
                            .getDownloadURL();
                      }

                      String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      DateTime currentTime = DateTime.now();

                      AddEntity addEntity = AddEntity(
                        taskname: taskNameController.text,
                        image: getUrl,
                        addId: addDataID,
                        userID: currentUserId,
                        dateTime: currentTime,
                      );

                      if (widget.updateAddEntity == null) {
                        await AddEntity.doc(addId: addDataID).set(addEntity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Task added successfully")),
                        );
                      } else {
                        await AddEntity.doc(addId: addDataID).update({
                          "taskname": taskNameController.text,
                          "image": getUrl ?? widget.updateAddEntity!.image,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Task updated successfully")),
                        );
                      }

                      setState(() {
                        isLoading = false;
                        taskNameController.clear();
                        pickImage = null;
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error adding task: $e")),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  getImage(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(source: source);
    if (imagePicker != null) {
      setState(() {
        pickImage = File(imagePicker.path);
      });
    }
  }
}
