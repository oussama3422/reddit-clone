import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallets.dart';

class SingInButton extends ConsumerWidget {
  const SingInButton({super.key});


  void singinWithGoogle(BuildContext context,WidgetRef ref){
   ref.read(authControllerProvider.notifier).singInWithGoogle(context);
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: ()=>singinWithGoogle(context,ref),
        icon: Image.asset(Constants.googlePath,height: 23,),
        label: const Text('Continue With Google',style:TextStyle(fontSize: 18)),
        style:ElevatedButton.styleFrom(
          backgroundColor:Pallete.greyColor,
          minimumSize: const Size(double.infinity,50),
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
      ),
    );
  }
}