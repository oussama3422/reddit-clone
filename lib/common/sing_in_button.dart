import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/theme/pallets.dart';

class SingInButton extends StatelessWidget {
  const SingInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: (){},
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