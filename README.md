# video_play

A new Flutter project for video upload and play. Use Firebase Authentication, Firebase storage and firestore.

This is assignment from TalentPro to **Humayun Kabir**

<table>
    <tr>
        <td align="center"><b>Humayun Kabir</b><br>(KabirFirm)</td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://github.com/KabirFirm">
                <image src="https://avatars.githubusercontent.com/u/4075816?s=400&u=878be022ef2a075c9da17604ac2cf4b70e55b9d4&v=4" width=100>
            </a>
        </td>
</table>

## Video CRUDs with Firestore Integration and AR-based Filtering with Maximum File Size Compression

## Instructions to run this project
1. `git clone git@github.com:KabirFirm/video-play-ar.git`
2. `flutter pub get` [run this command from terminal]
3. `compileSdkVersion` should be **33 or more**. `minSdkVersion` should be **23 or more**

## Assignment Details

**Firebase Authentication used to authenticate user. email/password feature enabled**

**Firebase Storage** - Firebase Storage used to store video and video thumbnail 

**FireStore** - FireStore is used as NoSQL database

**Video compression** - `video_compress` plugin is used to compress uploaded video. Here I used `VideoQuality.LowQuality` as quality for maximum compression.

**Augmented Reality (AR) filtering** - I used [DeepAR](https://www.deepar.ai/) for Augmented Reality filtering.

**Video thumbnail generation** - Video thumbnail is generated from uploaded video using `video_compress` plugin

**Error Handling** - Try,Catch block used for Error Handling

**Delete video** - right / left swipe to delete video from homepage list view.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

