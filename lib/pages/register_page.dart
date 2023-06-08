import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'cubits/auth_cubit/auth_cubit.dart';


class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';

  static GlobalKey<FormState> formKey = GlobalKey();

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          BlocProvider.of<AuthCubit>(context).isLoading = true;
        } else if (state is RegisterSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id,arguments: BlocProvider.of<AuthCubit>(context).email);
          BlocProvider.of<AuthCubit>(context).isLoading = false;
        } else if (state is RegisterFailure) {
          BlocProvider.of<AuthCubit>(context).isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: BlocProvider.of<AuthCubit>(context).isLoading,
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
                          'REGISTER',
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
                        BlocProvider.of<AuthCubit>(context).email = data;
                      },
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomFormTextField(
                      onChanged: (data) {
                        BlocProvider.of<AuthCubit>(context).password = data;
                      },
                      hintText: 'Password',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomButton(
                      text: 'REGISTER',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).registerUser(
                            email: BlocProvider.of<AuthCubit>(context).email!,
                            password: BlocProvider.of<AuthCubit>(context).password!,
                            context: context,
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '   Login',
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
        );
      },
    );
  }
}
