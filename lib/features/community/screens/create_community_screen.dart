import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';


class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}
class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  
  
  final TextEditingController communitynameController=TextEditingController();

  @override
  void dispose() {
    communitynameController.dispose();
    super.dispose();
  }

  void createCommunity(){
    ref.read(communtyControllerProvider.notifier).createCommuntiy(
      communitynameController.text.trim(),
      context
      );
  }
  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communtyControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Create Community'),
      ),
     body:isLoading?const Loader():Padding(
         padding: const EdgeInsets.all(11.0),
         child:   Column(
        children:  [
        const Align(
          alignment: Alignment.topLeft,
          child: Text('Community name',style: TextStyle(fontWeight: FontWeight.bold),)
          ),
        const SizedBox(height: 10),
        TextField(
          controller: communitynameController,
          decoration:const  InputDecoration(
            hintText: 'r/Community_name',
            filled:true,
            border:InputBorder.none,
            contentPadding:  EdgeInsets.all(10)
          ),
          maxLength: 21,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: createCommunity,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity,50),
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          child:const Text('Create Community',style: TextStyle(fontSize: 18)),
          )
    ],
  
  ),
),
    );
  }
}