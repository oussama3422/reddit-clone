import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constant/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath,height: 40),
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){}, child: const Text('Skip',style:TextStyle(fontWeight: FontWeight.bold)))
        ],
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text('Dive into anything',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 0.5)),
          Image.asset(Constants.loginEmotePath)
         ],
      ),
    );
  }
}