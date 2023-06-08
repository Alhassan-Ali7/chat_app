import 'package:bloc/bloc.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  bool isLoading = false;

  String? email;

  String? password;

  Future<void> loginUser(
      {required String email,
      required String password,
      required context}) async {
    emit(LoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure());
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      }else{
        showSnackBar(context, e.toString());
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
