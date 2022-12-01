import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/core/constant/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/pallets.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key,required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
    File? bannerFile;
    File? profileFile;

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


  void save(Community community){
    ref.read(communtyControllerProvider.notifier).editCommunity(
      profileFile: profileFile,
       bannerFile: bannerFile,
       community: community,
       context: context
       );
  }
  @override
  Widget build(BuildContext context) {
      final isLoding=ref.watch(communtyControllerProvider);
      final current=ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
    data:(community)=>Scaffold(
      backgroundColor:current.backgroundColor,
          appBar: AppBar(
            title:const Text('Edit Communtiy'),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed: ()=>save(community),
                child: const Text('Save')
                )
            ],
            ),
            body:
            isLoding
            ?
            const Loader()
            :
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
                                               color:current.textTheme.bodyText2!.color!,
                                               child:Container(
                            height:150,
                            width:double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child:bannerFile!=null?Image.file(bannerFile!):community.banner.isEmpty || community.banner == Constants.bannerDefault?const Center(child:Icon(Icons.camera_alt_outlined,size:40)):Image.network(community.banner,fit: BoxFit.fill,),
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
                            backgroundImage:NetworkImage(community.avatar),
                            radius:32,
                          ),
                        )
                        )
                  ],
                ),
                   ),
                ],
              ),
            )
    ),
    error: (error, stackTrace) =>ErrorText(error: error.toString()),
    loading: ()=>const Loader(), 
    );
  }
}