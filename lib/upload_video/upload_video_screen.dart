import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_play/global.dart';
import 'package:video_play/upload_video/upload_controller.dart';
import 'package:video_player/video_player.dart';

import '../utils.dart';
import '../widgets/input_text_widget.dart';

class UploadVideoScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  UploadVideoScreen(
  {
    required this.videoFile,
    required this.videoPath
  });

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {

  VideoPlayerController? playerController;
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();

  UploadController uploadVideoController = Get.put(UploadController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playerController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        playerController!.play();
        playerController!.setVolume(2);
        playerController!.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

/*    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });

    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String formatter = DateFormat('dd/MM/yyyy').format(now);// 28/03/2020

    dateTextEditingController.text = formatter;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.0,
              child: SizedBox(
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
                        VideoProgressIndicator(playerController!, allowScrubbing: true),
                      ],
                    ),
                    InkWell(
                      onTap: ()
                      {
                        setState(() {
                          playerController!.value.isPlaying
                              ? playerController!.pause()
                              : playerController!.play();
                        });
                      },
                      child: playerController!.value.isPlaying
                          ? const Icon(Icons.pause, color: Colors.white, size: 60.0,)
                          : const Icon(Icons.play_arrow, color: Colors.white, size: 60.0,),
                    )
                  ],
                )
                    : const SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

            const SizedBox(
              height: 30.0,
            ),

            showProgressBar == true
                ? Container(
                    child: const SimpleCircularProgressBar(
                      progressColors: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.red,
                        Colors.amber,
                        Colors.purpleAccent
                      ],
                      animationDuration: 30,
                      backColor: Colors.white,
                    )
                )
                : Column(
                    children: [
                      // title input field
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController: titleTextEditingController,
                            labelString: 'title',
                            iconData: Icons.title,
                            isObscure: false
                        ),
                      ),

                      const SizedBox(height: 10.0,),

                      // description input field
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController: descriptionTextEditingController,
                            labelString: 'description',
                            iconData: Icons.description,
                            isObscure: false
                        ),
                      ),

                      const SizedBox(height: 10.0,),

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

                      const SizedBox(height: 20.0,),

                      // upload now button
                      Container(
                        width: MediaQuery.of(context).size.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)
                            )
                        ),
                        child: InkWell(
                          onTap: () {

                            //todo - form validation change, use form
                            if(titleTextEditingController.text.isNotEmpty
                                && descriptionTextEditingController.text.isNotEmpty
                                && dateTextEditingController.text.isNotEmpty)
                            {
                              // show progressBar
                              setState(() {
                                showProgressBar = true;
                              });
                              // hide keyboard
                              hideKeyboard();
                              // upload video
                              uploadVideoController.saveVideoInfo(
                                  titleTextEditingController.text,
                                  descriptionTextEditingController.text,
                                  dateTextEditingController.text,
                                  widget.videoPath,
                                  context
                              );
                            }
                          },
                          child: const Center(
                              child: Text(
                                'Upload Now',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),

            // upload now btn clicked
            // circular progress bar

          ],
        ),
      ),
    );
  }
}
