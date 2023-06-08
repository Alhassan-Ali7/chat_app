import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app/pages/chat_page.dart';

//import 'package:chat_app/pages/cubits/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'cubits/chat_cubit/chat_cubit.dart';

class LoginPage extends StatelessWidget {
  static String id = 'login page';

  static GlobalKey<FormState> formKey = GlobalKey();

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          BlocProvider.of<AuthBloc>(context).isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id,
              arguments: BlocProvider.of<AuthBloc>(context).email);
          BlocProvider.of<AuthBloc>(context).isLoading = false;
        } else if (state is LoginFailure) {
          BlocProvider.of<AuthBloc>(context).isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: BlocProvider.of<AuthBloc>(context).isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 70.0,
                  ),
                  Image.asset(
                    kLogo,
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70.0,
                  ),
                  Row(
                    children: const [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      BlocProvider.of<AuthBloc>(context).email = data;
                    },
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      BlocProvider.of<AuthBloc>(context).password = data;
                    },
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoginEvent(
                            email: BlocProvider.of<AuthBloc>(context).email!,
                            password:
                                BlocProvider.of<AuthBloc>(context).password!,
                            context: context,
                          ),
                        );
                      }
                    },
                    text: 'LOGIN',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          '   Register',
                          style: TextStyle(
                            color: Color(0xffc7ede6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
