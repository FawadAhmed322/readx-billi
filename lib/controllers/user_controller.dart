import 'package:get/get.dart';
import 'package:readx/models/user_model.dart';

class UserController extends GetxController{
  UserModel? loggedInUser;
  RxBool isLoggedIn = false.obs;
}