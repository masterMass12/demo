import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/httprequests/get_chatbot_result.dart';
import 'package:ivrapp/screens/auth/auth_screen.dart';
import 'package:ivrapp/screens/chatscreen/widgets/chattextfield.dart';
import 'package:ivrapp/screens/chatscreen/widgets/messagebox.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  SpeechToText speechToText = SpeechToText();
  IconData icon = Icons.mic;
  bool fieldEmpty = true;
  String text = '';
  String reply = '';
  bool isListening = false;
  void activateMic() async {
    if (!isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() {
          isListening = true;
          speechToText.listen(onResult: (res) {
            setState(() {
              _chatcontroller.text = res.recognizedWords;
              fieldEmpty = false;
            });
          });
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatcontroller.dispose();
  }

  void isFieldEmpty(String text) {
    setState(() {
      if (text.trim().isNotEmpty) {
        fieldEmpty = false;
      } else {
        fieldEmpty = true;
      }
    });
  }

  void getreply() async {
    setState(() {
      userinput.add(MessageBox(text: '...', sender: 'bot'));
      scrolldown();
    });
    reply = await ChatbotResult()
        .getchatbotreult(context: context, userinput: text);
    setState(() {
      userinput.removeLast();
      userinput.add(MessageBox(
        text: reply,
        sender: 'bot',
      ));
    });
    scrolldown();
  }

  List<MessageBox> userinput = [
    MessageBox(
      text:
          'Hello!!. You can ask me anything about medicines and their side-effects. I will try to answer them correctly',
      sender: 'bot',
    ),
  ];

  void scrolldown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(
                Icons.logout,
                color: whiteColor,
              ))
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return userinput[index];
              },
              itemCount: userinput.length,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: CustomChatTextField(
                  onChanged: (newText) {
                    isFieldEmpty(newText);
                  },
                  hintText: 'Ask chatbot',
                  controller: _chatcontroller,
                  keyboardType: TextInputType.text,
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTapUp: (det) {
                    setState(() {
                      isListening = false;
                    });
                    speechToText.stop();
                  },
                  onTapDown: fieldEmpty
                      ? (det) async {
                          activateMic();
                        }
                      : (det) {
                          setState(() {
                            text = _chatcontroller.text.trim();
                            userinput.add(MessageBox(text: text));
                            getreply();
                            _chatcontroller.clear();
                            fieldEmpty = true;
                            popKeyboard(context);
                          });
                        },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: greenColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (!fieldEmpty)
                          ? Image.asset(
                              'assets/telegram.png',
                              fit: BoxFit.contain,
                              height: 30,
                              width: 30,
                            )
                          : Icon(
                              Icons.mic,
                              color: whiteColor,
                              size: 35,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, AuthScreen.routeName, (route) => false);
  }
}

void popKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}
