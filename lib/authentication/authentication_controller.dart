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
  final isLoading = false.obs;

  void createAccount(String userName, String email, String password) async
  {
    // start loading
    isLoading(true);
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
      // stop loading
      isLoading(false);
      // GetX state management will redirect user to home Screen automatically

    }catch(error) {
      Get.snackbar('Error', 'Error on signup');
      // stop loading
      isLoading(false);

    }
  }

  void loginUser(String email, String password) async
  {
    // start loading
    isLoading(true);
    try {
      // user in the firebase authentication
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );
      // stop loading
      isLoading(false);
      Get.snackbar('Success', 'Login successful');

      // GetX state management will redirect to HomeScreen automatically

    }catch(error) {
      // stop loading
      isLoading(false);
      Get.snackbar('Error', 'Error on login');
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