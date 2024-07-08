import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController Forgetcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LargeText(text: "Forget Password"),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: Forgetcontroller,
              text: "Enter your Email",
              Validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter your Email";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: "Send",
            onpressed: () {
              if (Forgetcontroller.text.isNotEmpty) {}
            },
          )
        ],
      ),
    );
  }
}
