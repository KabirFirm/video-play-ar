import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_play/authentication/authentication_controller.dart';
import 'package:video_play/authentication/signup_screen.dart';
import 'package:video_play/widgets/input_text_widget.dart';

import '../global.dart';
import '../utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  //bool showProgressBar = false;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  var authenticationController = AuthenticationController.instanceAuth;

  // todo: a) add Humayun Kabir text and change font b) remove showProgressBar and apply loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: loginFormKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),

                Text(
                    'Login Screen',
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

                // email textfield
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                      textEditingController: emailTextEditingController,
                      labelString: 'Email',
                      iconData: Icons.email_outlined,
                      isObscure: false,
                      isEmail: true,
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


                // login button
                showProgressBar == false ?
                Column(
                  // todo: a) remove column
                  children: [
                    // login
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

                          final form = loginFormKey.currentState;
                          if(form!.validate())
                            {
                              // login user now
                              setState(() {
                                showProgressBar = true;
                              });

                              // hide keyboard
                              hideKeyboard();

                              authenticationController.loginUser(
                                  emailTextEditingController.text,
                                  passwordTextEditingController.text
                              );
                            }
                        },
                        child: const Center(
                            child: Text(
                                'Login',
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
                            'Don\'t have an account ? ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                          ),
                        ),
                        InkWell(
                          onTap: ()
                          {
                            // send user to signup page
                            Get.to(const SignupScreen());
                          },
                          child: const Text(
                            'Signup Now',
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
      ),
    );
  }
}
