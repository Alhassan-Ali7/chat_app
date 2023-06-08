import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/models/messaage.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  String? text;

  TextEditingController controller = TextEditingController();
  List<Message> messagesList = [];

  final _control = ScrollController();

  @override
  Widget build(BuildContext context) {
    String? email = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text(
              'Chat',
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  reverse: true,
                  controller: _control,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].id == email
                        ? ChatBuble(
                            message: messagesList[index],
                          )
                        : ChatBubleForFriend(
                            message: messagesList[index],
                          );
                  },
                );
              },
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messagesList = state.messages;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Send Messages',
                suffixIcon: IconButton(
                  onPressed: () {
                    BlocProvider.of<ChatCubit>(context).sendMessage(
                      message: controller.text,
                      email: email!,
                    );
                    controller.clear();
                    _control.animateTo(
                      0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    );
                  },
                  icon: const Icon(
                    Icons.send,
                  ),
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
