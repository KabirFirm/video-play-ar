import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_play/home/home_screen.dart';
import 'package:video_play/upload_video/video_model.dart';

import '../global.dart';

class UploadController extends GetxController
{

  static UploadController instanceUpload = Get.find();
  final isLoading = false.obs;

  compressVideoFile(String videoFilePath) async
  {
    final compressedVideoFile = await VideoCompress.compressVideo(videoFilePath, quality: VideoQuality.LowQuality);

    return compressedVideoFile!.file;
  }

  uploadVideoFile(String videoID, String videoFilePath) async
  {
    UploadTask videoUploadTask = FirebaseStorage.instance.ref()
        .child("All Videos")
        .child(videoID)
        .putFile(await compressVideoFile(videoFilePath));

    TaskSnapshot snapshot = await videoUploadTask;

    String downloadUrlOfVideo = await snapshot.ref.getDownloadURL();

    return downloadUrlOfVideo;
  }

  getThumbnailImage(String videoFilePath) async
  {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);

    return thumbnailImage;
  }

  uploadThumbnailImage(String videoID, String videoFilePath) async
  {
    UploadTask thumbnailUploadTask = FirebaseStorage.instance.ref()
        .child("All Thumbnails")
        .child(videoID)
        .putFile(await getThumbnailImage(videoFilePath));

    TaskSnapshot snapshot = await thumbnailUploadTask;

    String downloadUrlOfThumbnail = await snapshot.ref.getDownloadURL();

    return downloadUrlOfThumbnail;
  }

  saveVideoInfo(String title, String description, String uploadDate, String videoFilePath, BuildContext context) async
  {
    // start loading
    isLoading(true);
    try {
      // get current user information from FireStore
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      String videoID = DateTime.now().millisecondsSinceEpoch.toString();

      // upload video to Firebase storage
      String videoDownloadUrl = await uploadVideoFile(videoID, videoFilePath);

      // upload video thumbnail to Firebase storage
      String thumbnailDownloadUrl = await uploadThumbnailImage(videoID, videoFilePath);

      // save video info to Firestore Database
      Video videoObject = Video(
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        videoID: videoID,
        title: title,
        description: description,
        uploadDate: uploadDate,
        videoDownloadUrl: videoDownloadUrl,
        thumbnailDownloadUrl: thumbnailDownloadUrl,
        isActive: true,
      );
      
      await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());
      // stop loading
      isLoading(false);

      Get.offAll(HomeScreen());
      //showProgressBar = false;
      Get.snackbar("Success", "New video upload success");

    }catch(error) {
      // stop loading
      isLoading(false);
      Get.snackbar('Error', 'video upload failed');
    }
  }
}