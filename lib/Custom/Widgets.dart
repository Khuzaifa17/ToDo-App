// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  String text;
  Color? color;
  LargeText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
    );
  }
}

class SmallText extends StatelessWidget {
  String text;
  Color? color;
  SmallText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: color),
    );
  }
}

class DefaultText extends StatelessWidget {
  String text;
  Color? color;
  DefaultText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: color),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String? text;
  TextEditingController controller;
  IconData? icon;
  final String? Function(String?)? Validation;
  CustomTextField(
      {super.key,
      required this.controller,
      required this.text,
      this.icon,
      this.Validation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: TextFormField(
        controller: controller,
        validator: Validation,
        decoration: InputDecoration(
            labelText: text,
            border: const OutlineInputBorder(),
            suffixIcon: Icon(icon)),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  String text;
  final VoidCallback onpressed;
  CustomButton({super.key, required this.text, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomTextbutton extends StatelessWidget {
  String text;
  Color? color;
  final VoidCallback ontap;
  CustomTextbutton(
      {super.key, required this.text, required this.ontap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: color),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  String text;
  CustomContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.maxFinite,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Center(child: LargeText(text: text, color: Colors.white)),
    );
  }
}

class Custombar extends StatelessWidget {
  IconData icon;
  String text;
  Color color;
  Custombar(
      {super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 60,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.indigo, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            SizedBox(
              width: 40,
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            DefaultText(
              text: text,
              color: color,
            )
          ],
        ),
      ),
    );
  }
}
