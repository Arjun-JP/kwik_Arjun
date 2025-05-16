import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/update_user_repo.dart';

class UpdateProfileBottomSheet extends StatefulWidget {
  const UpdateProfileBottomSheet({
    super.key,
  });

  @override
  State<UpdateProfileBottomSheet> createState() =>
      _UpdateProfileBottomSheetState();
}

class _UpdateProfileBottomSheetState extends State<UpdateProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final UpdateUeserRepo updateuserrepo = UpdateUeserRepo();
  @override
  initState() {
    getuseremail();
    _nameController.text = user?.displayName ?? "";

    super.initState();
  }

  getuseremail() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      final data = doc.data();

      final email = data?['email'];
      print("Firestore email: $email");
      _emailController.text = email;
      return email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Email ${user!.email}");
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Text("Update Profile",
                  style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: AppColors.buttonColorOrange)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                initialValue: user?.email,
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: AppColors.buttonColorOrange)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: .05, color: AppColors.buttonColorOrange)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final emailPattern =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  } else if (!emailPattern.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await user?.updateDisplayName(_nameController.text);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({
                      'email': _emailController.text,
                    });
                    updateuserrepo.updateuserinmogo(
                        email: _emailController.text,
                        name: _nameController.text);
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF592E),
                  foregroundColor: const Color(0xFFFFFFFFF),
                  minimumSize: const Size.fromHeight(45),
                ),
                child: Text("Save Changes",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.white)),
              ),
              SizedBox(height: Platform.isIOS ? 20 : 40),
            ],
          ),
        ),
      ),
    );
  }
}
