import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/LoginScreen.dart';
import 'package:flutter_application_1/Custom/BottomNavigation.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/user_entity.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomContainer(text: "SignUp"),
            SizedBox(
              height: 60,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    text: "Name",
                    Validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    text: "Enter your email",
                    Validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordController,
                    text: "Password",
                    Validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: confirmController,
                    text: "Confirm Password",
                    Validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Re-Enter Your Password';
                      }
                      if (value != passwordController.text.trim()) {
                        return 'Password does not Match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Sign Up",
                          onpressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                              String userID =
                                  FirebaseAuth.instance.currentUser!.uid;

                              UserEntity userEntity = UserEntity(
                                email: emailController.text.trim(),
                                name: nameController.text.trim(),
                                userId: userID,
                              );
                              await UserEntity.doc(userId: userID)
                                  .set(userEntity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Account Created Successfully")));

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNaviScreen(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultText(
                  text: "Already have an account?",
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: DefaultText(
                      text: "LogIn",
                      color: Colors.indigo,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
