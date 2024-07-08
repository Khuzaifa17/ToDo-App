import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/ForgetPassword.dart';
import 'package:flutter_application_1/Auth/SignUP.dart';
import 'package:flutter_application_1/Custom/BottomNavigation.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(text: "Login"),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: SmallText(
              text: "WELCOME BACK",
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: emailcontroller,
                    text: "Email",
                    Validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please Enter your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: passwordcontroller,
                    text: "Password",
                    icon: Icons.visibility,
                    Validation: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Please Enter Your Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CustomTextbutton(
                          text: "Forget Password?",
                          color: Colors.blue,
                          ontap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: isloading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Login",
                            onpressed: () async {
                              if (_formkey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailcontroller.text,
                                          password:
                                              passwordcontroller.text.trim());
                                  setState(() {
                                    isloading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNaviScreen(),
                                      ));
                                } catch (e) {
                                  setState(() {
                                    isloading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.indigo,
                                          content: Text(
                                              'You dont have an Account, SignUp First')));
                                }
                              }
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultText(
                        text: "Dont Have'nt an Account?",
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomTextbutton(
                        text: "SignUp",
                        color: Colors.blue,
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ));
                        },
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
