import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:video_play/upload_video/video_model.dart';
import 'package:video_player/video_player.dart';

import '../global.dart';
import '../utils.dart';
import '../widgets/input_text_widget.dart';
import 'home_controller.dart';

class VideoDetails extends StatefulWidget {
  final Video videoData;

  VideoDetails({required this.videoData});

  @override
  _VideoDetailsState createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoPlayerController? playerController;
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleTextEditingController.text = widget.videoData.title!;
    descriptionTextEditingController.text = widget.videoData.description!;
    dateTextEditingController.text = widget.videoData.uploadDate!;

    playerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoData.videoDownloadUrl!))
      ..initialize().then((_) {
        playerController!.play();
        playerController!.setVolume(2);
        playerController!.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LoadingOverlay(
          isLoading: homeController.isLoading.value,
          color: Colors.grey,
          opacity: 0.5,
          child: SingleChildScrollView(
            child: Form(
              key: updateFormKey,
              child: Column(
                children: [
                  // display video player
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.0,
                    child: playerController!.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  VideoPlayer(playerController!),
                                  VideoProgressIndicator(playerController!,
                                      allowScrubbing: true),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    playerController!.value.isPlaying
                                        ? playerController!.pause()
                                        : playerController!.play();
                                  });
                                },
                                child: playerController!.value.isPlaying
                                    ? const Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                        size: 60.0,
                                      )
                                    : const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 60.0,
                                      ),
                              )
                            ],
                          )
                        : const SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                  ),

                  const SizedBox(
                    height: 30.0,
                  ),

                  Column(
                    children: [
                      // title input field
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController: titleTextEditingController,
                            labelString: 'title',
                            iconData: Icons.title,
                            isObscure: false),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      // description input field
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController:
                                descriptionTextEditingController,
                            labelString: 'description',
                            iconData: Icons.description,
                            isObscure: false),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      // upload date field
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                          textEditingController: dateTextEditingController,
                          labelString: 'upload date',
                          iconData: Icons.calendar_month,
                          isObscure: false,
                          isEnable: false,
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // upload now button
                      Container(
                        width: MediaQuery.of(context).size.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: InkWell(
                          onTap: () {
                            final form = updateFormKey.currentState;
                            if(form!.validate()) {
                              // hide keyboard
                              hideKeyboard();
                              // upload video
                              homeController.updateVideoInfo(
                                  titleTextEditingController.text,
                                  descriptionTextEditingController.text,
                                  widget.videoData,
                                  context);
                            }
                          },
                          child: const Center(
                              child: Text(
                            'Update',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),

                      // back button
                      Container(
                        width: MediaQuery.of(context).size.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Center(
                              child: Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),

                  // upload now btn clicked
                  // circular progress bar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
