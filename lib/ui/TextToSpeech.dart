import 'package:flutter/material.dart';

import '../constant/MyAppColor.dart';
import 'package:flutter_tts/flutter_tts.dart';



class TextToSpeech extends StatefulWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {

  FlutterTts ftts = FlutterTts();


  @override
  void initState() {
    super.initState();
    textSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('TextToSpeech',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: Container(
        child: Center(child: Text('Text to Speech')),
      ),
    );
  }

  Future<void> textSpeech() async {
    //your custom configuration
    //await ftts.setLanguage("en-US");
    await ftts.setLanguage("hi");
    await ftts.setSpeechRate(0.5); //speed of speech
    await ftts.setVolume(2.0); //volume of speech
    await ftts.setPitch(1); //pitc of sound

    //play text to speech
    var result = await ftts.speak("जी,आपके शिशु का वजन उम्र के अनुसार सही है।");
    if(result == 1){
      //speaking

    }else{
      //not speaking
    }
  }
}
