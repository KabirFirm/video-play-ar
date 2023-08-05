import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_play/authentication/login_screen.dart';
import 'package:video_play/authentication/signup_screen.dart';
import 'package:video_play/global.dart';
import 'package:video_play/home/home_screen.dart';
import 'user_model.dart' as userModel;

class AuthenticationController extends GetxController
{

  static AuthenticationController instanceAuth = Get.find();
  late Rx<User?> _currentUser;

  void createAccount(String userName, String email, String password) async
  {
    try {
      // create user in the firebase authentication
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // save user data in firestore database
      userModel.User user = userModel.User(
          name: userName,
          email: email,
          uid: credential.user!.uid
      );

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(user.toJson());

      Get.snackbar('Success', 'Signup successful');
      showProgressBar = false;
      // GetX state management will redirect user to home Screen automatically

    }catch(error) {
      Get.snackbar('Error', 'Error on signup');
      showProgressBar = false;
      Get.to(LoginScreen());
    }
  }

  void loginUser(String email, String password) async
  {
    try {
      // user in the firebase authentication
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );

      Get.snackbar('Success', 'Login successful');
      showProgressBar = false;

      // GetX state management will redirect to HomeScreen automatically

    }catch(error) {
      Get.snackbar('Error', 'Error on login');
      showProgressBar = false;
      Get.to(SignupScreen());
    }
  }

  goToScreen(User? currentUser)
  {
    print('currentUser - $currentUser');
    // user is not logged in
    if(currentUser == null)
      {
        Get.offAll(LoginScreen());
      }else
        {
          // when user is already logged in
          Get.offAll(HomeScreen());
        }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // get the current user state into app
     _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
     _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
     ever(_currentUser, goToScreen);
  }

  void logoutUser() async{
    Get.snackbar('Success', 'Logout successful');
    await FirebaseAuth.instance.signOut();
  }
}