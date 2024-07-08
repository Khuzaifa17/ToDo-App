import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Auth/LoginScreen.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/user_entity.dart';
import 'package:flutter_application_1/Screens/EditScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? pickimage;
  String? ImageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          CustomContainer(
            text: "Profile",
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
              stream:
                  UserEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading profile data'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Center(
                    child: Text('Profile data not available'),
                  );
                }

                UserEntity profileData = snapshot.data!.data()!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      profileData.profileImage != null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.data()!.profileImage!),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.indigo.shade100,
                              child: const Center(
                                  child: Icon(
                                Icons.camera_alt,
                                size: 45,
                              )),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  LargeText(
                                    text: profileData.name!,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                updateUserEntity: profileData,
                                              ),
                                            ));
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                            ),
                            Text(profileData.email!)
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Custombar(
                icon: Icons.book,
                text: "Term and Condition",
                color: Colors.white,
              ),
              Custombar(
                  icon: Icons.privacy_tip_sharp,
                  text: "Privacy & Policy",
                  color: Colors.white),
              Custombar(
                  icon: Icons.contact_page,
                  text: "Contact",
                  color: Colors.white),
              InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            height: 120,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Are you sure you want to logout?"),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onHover: (value) => true,
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ));
                                        },
                                        child: Text("Logout",
                                            style:
                                                TextStyle(color: Colors.red))),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // await FirebaseAuth.instance.signOut();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //   builder: (context) => const LoginScreen(),
                    // ));
                  },
                  child: Custombar(
                      icon: Icons.logout, text: "LogOut", color: Colors.white)),
            ],
          ),
        ],
      ),
    ));
  }
}
