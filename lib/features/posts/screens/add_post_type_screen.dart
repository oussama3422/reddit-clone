import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/community.dart';

import '../../../core/utils.dart';
import '../../../theme/pallets.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key,required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  File? bannerFile;
  final titleController=TextEditingController();
  final descriptionController=TextEditingController();
  final linkController=TextEditingController();
  List<Community> commuties=[];
  Community? selectedCommunity;
  @override
  void dispose() { 
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();

  }
void selectBannerImage()async{
    final res=await pickImage();
    if (res!=null){
          setState(() {
            bannerFile=File(res.files.first.path!);
          });
    }
  }
 
  void sharePosts(){
    if (widget.type == 'image' && bannerFile!=null && titleController.text.isNotEmpty){
      ref.read(postsContollerProvider.notifier).shareImagePost(
       context: context,
       title: titleController.text.trim(),
       selectedCommunity: selectedCommunity  ?? commuties[0],
       image: bannerFile,
      );
    }else if (widget.type == 'text' && descriptionController.text.isNotEmpty){
         ref.read(postsContollerProvider.notifier).shareTextPost(
          context: context,
           title: titleController.text.trim(),
           selectedCommunity: selectedCommunity  ?? commuties[0],
           description: descriptionController.text.trim(),
           );
    }else if (widget.type == 'link' && linkController.text.isNotEmpty && titleController.text.isNotEmpty ){
      ref.read(postsContollerProvider.notifier).shareLinkPost(
        context: context,
         title: titleController.text.trim(),
         selectedCommunity: selectedCommunity ?? commuties[0],
         links: linkController.text.trim(),
         );
    }else{
        showSnackBar(context,'please Enter all the field');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage=widget.type=='image';
    final isTypeText=widget.type=='text';
    final isTypeLink=widget.type=='link';

    final currentTheme=ref.watch(themeNotifierProvider);

    final isLoading=ref.watch(postsContollerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
              TextButton(
                onPressed: sharePosts,
                child: const Text('Share')
                )
        ],
      ),
      body:isLoading?const Loader(): Padding(
        padding: const EdgeInsets.all(8.0),
        child:Column(
          children: [
            TextField(
              controller: titleController,
              decoration:const InputDecoration(
                filled:true,
                hintText:'Enter Title Here',
                border:InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength:30,
            ),
            const SizedBox(height:10),
            if(isTypeImage)
             InkWell(
                  onTap:selectBannerImage,
                  child: DottedBorder(
                        radius: const Radius.circular(20),
                        dashPattern: const[13,7],
                        strokeCap:StrokeCap.round,
                        color:currentTheme.textTheme.bodyText2!.color!,
                      child:Container(
                            height:150,
                            width:double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: 
                                bannerFile!=null
                                  ?
                                  Image.file(bannerFile!)
                                 :
                                const Center(
                                  child:Icon(
                                    Icons.camera_alt_outlined,
                                    size:40
                                    )
                                  )
                              ),
                            ),
                         ),
            if (isTypeText)
                TextField(
                            controller: descriptionController,
                            decoration:const InputDecoration(
                            filled:true,
                            hintText:'Enter Description here',
                            border:InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                           ),
                           maxLines: 5,
                         ),
           if (isTypeLink)
               TextField(
                            controller: linkController,
                            decoration:const InputDecoration(
                            filled:true,
                            hintText:'Enter link here',
                            border:InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                            
                          ),
                ),
                const SizedBox(height:20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Select Community'),
                  ),
                  ref.watch(userCommunityProvider).when(
                    data: (data){
                          commuties=data;
                          if(data.isEmpty){
                            return const SizedBox();
                          }
                          return DropdownButton(
                            value:selectedCommunity ?? data[0],
                            items: data.map(
                              (community) => DropdownMenuItem(
                              value:community,
                              child: Text(community.name)
                              )
                              ).toList(),
                            onChanged:(newItem){
                              setState((){
                                    selectedCommunity=newItem;
                              });
                            },
                            );

                    },
                    error: (error,stacktrace)=>ErrorText(error: error.toString()),
                    loading: ()=>const Loader(),
                    )
          ],
        ),
      )
    );
  }
}