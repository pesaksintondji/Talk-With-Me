import 'package:flutter_config/flutter_config.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talk_with_me/messages.dart';
import 'package:talk_with_me/status-handler.dart';

class OpenAIHandler {
  static OpenAI openAI = new OpenAI(apiKey: FlutterConfig.get('OPENAI_API_KEY'));
  static String currentText = 
  "Sam: Hi! I'm your therapist, Sam. What would you like to talk about?\nUser: ";
  static String aiResponse = '';

  static complete(String response) async {
    currentText += response + "\nSam:";
    String generated = await openAI.complete(currentText, 40);
    int end = generated.indexOf('\n');
    aiResponse = generated.substring(1, end == -1 ? 29 : end);
    currentText += generated.substring(0, generated.indexOf('\n') + 1);
    currentText += 'User:';
    //print(currentText);
    print(aiResponse);
    Messages.addMessage(Message(false, aiResponse));
    _playResponse();
  }

  static _playResponse() async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(aiResponse);
    CurrentStatus.status = TalkStatus.user_talking;
  }
}