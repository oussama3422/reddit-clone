import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/common/sing_in_button.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});


   void singInAsGuest(WidgetRef ref,BuildContext context){
    ref.read(authControllerProvider.notifier).singInAsGuest(context);
   }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading=ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath,height: 40),
        centerTitle: true,
        actions: [
          TextButton(onPressed: ()=>singInAsGuest(ref,context), child: const Text('Skip',style:TextStyle(fontWeight: FontWeight.bold)))
        ],
        ),
      body:isLoading? const Loader(): Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text('Dive Into Anything',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 0.5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmotePath),
          ),
          const SizedBox(height: 30),
          const SingInButton()
         ],
      ),
    );
  }
}