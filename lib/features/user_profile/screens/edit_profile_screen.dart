import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';

import '../../../common/error_text.dart';
import '../../../common/loader.dart';
import '../../../core/constant/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/pallets.dart';
import '../../community/controller/community_controller.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key,required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() { 
    print('Start dispose');
    super.initState();
    nameController=TextEditingController(text:ref.read(userProvder)!.name);
  }
  @override
  void dispose() {
    print('Start dispose');
    nameController.dispose();
    super.dispose();
  }
  void selectBannerImage()async{
    final res=await pickImage();
    if (res!=null){
          setState(() {
            bannerFile=File(res.files.first.path!);
          });
    }
  }
  void selectProfileImage()async{
    final res=await pickImage();
    if (res!=null){
          setState(() {
            profileFile=File(res.files.first.path!);
          });
    }
  }
  void save(){
    ref.read(userProfileControllerProvider.notifier).editProfile(
      profileFile: profileFile,
       bannerFile: bannerFile,
       context: context,
       name:nameController.text.trim(),
      );
  }
  @override
  Widget build(BuildContext context) {
    print('build func start');
    final isLoading=ref.watch(userProfileControllerProvider);
   return ref.watch(getUserDataProvider(widget.uid)).when(
    data:(user)=>Scaffold(
      backgroundColor:Pallete.darkModeAppTheme.backgroundColor ,
          appBar: AppBar(
            title:const Text('Edit Communtiy'),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed: save,
                child: const Text('Save')
                )
            ],
            ),
            body:isLoading?const Loader():
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                   SizedBox(
                    height:200,
                     child: Stack(
                       children:[
                         InkWell(
                          onTap:selectBannerImage,
                           child: DottedBorder(
                                               radius: const Radius.circular(20),
                                               dashPattern: const[13,7],
                                               strokeCap:StrokeCap.round,
                                               color:Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                                               child:Container(
                            height:150,
                            width:double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child:bannerFile!=null?Image.file(bannerFile!):user.banner.isEmpty || user.banner == Constants.bannerDefault?const Center(child:Icon(Icons.camera_alt_outlined,size:40)):Image.network(user.banner,fit: BoxFit.fill,),
                                               )
                                              ),
                         ),
                       Positioned(
                        bottom:20,
                        left:20,
                        child: InkWell(
                          onTap:selectProfileImage,
                          child:profileFile!=null
                          ?
                           CircleAvatar(
                            backgroundImage:FileImage(profileFile!),
                            radius:32,
                          )
                          :
                         CircleAvatar(
                            backgroundImage:NetworkImage(user.profilePic),
                            radius:32,
                          ),
                        )
                        )
                     ],
                   ),
                   ),
                   TextField(
                    controller:nameController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide:const  BorderSide(color:Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                   )
                ],
              ),
            )
    ),
    error: (error, stackTrace) =>ErrorText(error: error.toString()),
    loading: ()=>const Loader(), 
    );
  }
}