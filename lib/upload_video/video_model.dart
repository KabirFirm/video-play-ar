import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String? userID;
  String? userName;
  String? videoID;
  String? title;
  String? description;
  String? uploadDate;
  String? videoDownloadUrl;
  String? thumbnailDownloadUrl;
  bool? isActive;


  Video({
    this.userID,
    this.userName,
    this.videoID,
    this.title,
    this.description,
    this.uploadDate,
    this.videoDownloadUrl,
    this.thumbnailDownloadUrl,
    this.isActive
  });

  Map<String, dynamic> toJson() =>
      {
        "userID" : userID,
        "userName" : userName,
        "videoID" : videoID,
        "title" : title,
        "description" : description,
        "uploadDate" : uploadDate,
        "videoDownloadUrl" : videoDownloadUrl,
        "thumbnailDownloadUrl" : thumbnailDownloadUrl,
        "isActive" : isActive,
      };

  static Video fromSnap(DocumentSnapshot snapshot)
  {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Video(
      userID: dataSnapshot['userID'],
      userName: dataSnapshot['userName'],
      videoID: dataSnapshot['videoID'],
      title: dataSnapshot['title'],
      description: dataSnapshot['description'],
      uploadDate: dataSnapshot['uploadDate'],
      videoDownloadUrl: dataSnapshot['videoDownloadUrl'],
      thumbnailDownloadUrl: dataSnapshot['thumbnailDownloadUrl'],
      isActive: dataSnapshot['isActive'],
    );
  }
}