import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoices;
  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);

        print(_voices);
        setState(() {
          _voices = _voices
              .where((_voices) => _voices["name"].contains("en"))
              .toList();
          _currentVoices = _voices.first;
          setVoice(_currentVoices!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _flutterTts.speak(TTS_INPUT);
        },
        child: const Icon(Icons.speaker_phone),
      ),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _speakerSelector(),
        ],
      ),
    );
  }

  Widget _speakerSelector() {
    return DropdownButton(
        value: _currentVoices,
        items: _voices
            .map((_voice) => DropdownMenuItem(
                value: _voice,
                child: Text(
                  _voice["name"],
                )))
            .toList(),
        onChanged: (value) {});
  }
}
