import 'package:bloc/bloc.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  bool isLoading = false;

  String? email;

  String? password;


  Future<void> registerUser(
      {required String email,
      required String password,
      required context}) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure());
      if (e.code == 'weak-password') {
        showSnackBar(context,
            'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context,
            'The account already exists for that email.');
      }else{
        showSnackBar(context, e.toString());
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
