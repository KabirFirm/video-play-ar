import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_play/authentication/authentication_controller.dart';
import 'package:video_play/authentication/login_screen.dart';
import 'package:video_play/utils.dart';

import '../global.dart';
import '../widgets/input_text_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),

              Text(
                'Signup Screen',
                style: GoogleFonts.akayaKanadaka(
                    fontSize: 35.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 30.0,),
              Text(
                'This is prepared by Humayun Kabir',
                style: GoogleFonts.akayaKanadaka(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal
                ),
              ),
              const SizedBox(height: 30.0,),
              // username textfield
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: userNameTextEditingController,
                    labelString: 'Username',
                    iconData: Icons.person_outline,
                    isObscure: false
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // email textfield
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: emailTextEditingController,
                    labelString: 'Email',
                    iconData: Icons.email_outlined,
                    isObscure: false
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              // password textfield
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: passwordTextEditingController,
                    labelString: 'Password',
                    iconData: Icons.lock_outline,
                    isObscure: true
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              // signup button
              showProgressBar == false ?
              Column(
                // todo: a) remove column
                children: [
                  // signup button
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
                        if(userNameTextEditingController.text.isNotEmpty
                            && emailTextEditingController.text.isNotEmpty
                            && passwordTextEditingController.text.isNotEmpty)
                          {
                            // show progressBar
                            setState(() {
                              showProgressBar = true;
                            });
                            // hide keyboard
                            hideKeyboard();
                            // create account for user
                            authenticationController.createAccount(
                                userNameTextEditingController.text,
                                emailTextEditingController.text,
                                passwordTextEditingController.text
                            );


                          }
                      },
                      child: const Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  // not have an account text and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account ? ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                        ),
                      ),
                      InkWell(
                        onTap: ()
                        {
                          // send user to login page
                          Get.to(const LoginScreen());
                        },
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ) : Container(
                // show animation
                child: const SimpleCircularProgressBar(
                  progressColors: [
                    Colors.green,
                    Colors.blueAccent,
                    Colors.red,
                    Colors.amber,
                    Colors.purpleAccent
                  ],
                  animationDuration: 3,
                  backColor: Colors.white,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
