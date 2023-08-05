import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_play/upload_video/ar_filtering.dart';

import '../global.dart';
import '../upload_video/upload_video_screen.dart';
import '../upload_video/video_model.dart';
import 'home_screen.dart';

class HomeController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;
  final isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _videoList.bindStream(
        FirebaseFirestore.instance.collection('videos').snapshots().map((QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Video.fromSnap(element),
            );
          }
          return retVal;
        }));
  }

  getVideoFile(ImageSource imageSource) async
  {
    //
    final videoFile = await ImagePicker().pickVideo(source: imageSource);

    if(videoFile != null)
    {
      // video upload screen
      Get.to(
        UploadVideoScreen(
          videoFile: File(videoFile.path),
          videoPath: videoFile.path,
        ),
      );
    }
  }

  displayDialogBox(BuildContext context)
  {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: ()
              {
                getVideoFile(ImageSource.gallery);
                // dismiss dialog
                Get.back();
              },
              child: Row(
                children: const [
                  Icon(Icons.image),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Get video from Gallery',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: ()
              {
                // todo - implement AR filtering here
                Get.to(() => ARFiltering());
                //getVideoFile(ImageSource.camera);
                // dismiss dialog
                //Get.back();
              },
              child: Row(
                children: const [
                  Icon(Icons.camera),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Capture video using Camera',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: ()
              {
                // disappear dialog box
                Get.back();
              },
              child: Row(
                children: const [
                  Icon(Icons.cancel),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  updateVideoInfo(String newTitle, String newDescription, Video videoData, BuildContext context) async
  {
    // start loading
    isLoading(true);
    try {
      // get current user information from FireStore
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      String videoID = videoData.videoID!;//DateTime.now().millisecondsSinceEpoch.toString();


      // save video info to Firestore Database
      Video videoObject = Video(
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        videoID: videoID,
        title: newTitle,
        description: newDescription,
        uploadDate: videoData.uploadDate,
        videoDownloadUrl: videoData.videoDownloadUrl,
        thumbnailDownloadUrl: videoData.thumbnailDownloadUrl,
        isActive: true,
      );

      await FirebaseFirestore.instance.collection("videos").doc(videoID).update(videoObject.toJson());

      Get.offAll(HomeScreen());
      // stop loading
      isLoading(false);
      Get.snackbar("Success", "New video upload success");

    }catch(error) {
      // stop loading
      isLoading(false);
      Get.snackbar('Error', 'video update failed');
      print('error - $error');
    }
  }

  deleteVideoInfo(Video videoData, BuildContext context) async
  {
    // start loading
    isLoading(true);
    try {
      await FirebaseFirestore.instance.collection("videos").doc(videoData.videoID).delete();

      Get.offAll(HomeScreen());
      // stop loading
      isLoading(false);
      Get.snackbar("Success", "Video delete success");

    }catch(error) {
      // stop loading
      isLoading(false);
      Get.snackbar('Error', 'Video delete failed');
    }
  }
}