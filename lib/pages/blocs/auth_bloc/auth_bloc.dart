import 'package:bloc/bloc.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoading = false;

  String? email;

  String? password;
  AuthBloc() : super(AuthInitial()) {

    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(LoginSuccess());
        } on FirebaseAuthException catch (e) {
          emit(LoginFailure());
          if (e.code == 'user-not-found') {
            showSnackBar(event.context, 'No user found for that email.');
          } else if (e.code == 'wrong-password') {
            showSnackBar(
                event.context, 'Wrong password provided for that user.');
          } else {
            showSnackBar(event.context, e.toString());
          }
        } catch (e) {
          showSnackBar(event.context, e.toString());
        }
      }
    });
    // void onTransition(Transition<AuthEvent, AuthState> transition){
    //   super.onTransition(transition);
    // }
  }
}
