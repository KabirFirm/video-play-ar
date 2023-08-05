import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_play/authentication/authentication_controller.dart';
import 'package:video_play/home/home_controller.dart';
import 'package:video_play/home/video_details.dart';
import 'package:video_play/upload_video/ar_filtering.dart';
import 'package:video_play/upload_video/upload_video_screen.dart';

import '../upload_video/upload_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var authenticationController = AuthenticationController.instanceAuth;
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
        actions: [
          PopupMenuButton(
              onSelected: (result) {
                if(result == 1) {
                  authenticationController.logoutUser();
                }
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.asset("assets/images/no-photo.jpg"),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ];
              }
          )
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: homeController.videoList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = homeController.videoList[index];
            return Dismissible(
              key: Key(data.videoID!),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to delete this video?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("DELETE", style: TextStyle(color: Colors.red),)
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async{
                  // Remove the item from the data source.
                  homeController.deleteVideoInfo(data, context);
                },
              background: Container(color: Colors.red),
              child: Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: ()
                  {
                    // Go to video details page
                    Get.to(VideoDetails(videoData: data));
                  },
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      height: 70.0,//MediaQuery.of(context).size.height * 0.3,
                      width: 60.0,//MediaQuery.of(context).size.height * 0.2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/no-image.png",
                            image: data.thumbnailDownloadUrl!,
                            fit: BoxFit.fill,
                          ),
                        ),
                    ),
                    title: Text('${data.title}'),
                    subtitle: Text('${data.description}'),
                    trailing: Text('${data.uploadDate}'),
                  ),
                ),
              ),
            );
            }
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          // upload video from here
          homeController.displayDialogBox(context);
        },
        label: const Text('Upload'),
        icon: const Icon(Icons.upload),
      ),
    );
  }
}
