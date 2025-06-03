import 'package:flutter/material.dart';
import 'package:fit_rpg/Services/audio_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _musicVolume = AudioService().musicVolume;
  double _sfxVolume = AudioService().sfxVolume;
  final double _cardSFXVolume = AudioService().cardSFXVolume;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,       
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Stats_BG.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  'Music Volume: ${(_musicVolume * 100).round()}%',
                   style: TextStyle(fontSize: 24)),
                Slider(
                  thumbColor: Colors.black,
                  activeColor: Colors.black.withAlpha(200),
                  inactiveColor: Colors.black.withAlpha(96),
                  
                  value: _musicVolume,
                  onChanged: (value) {
                    setState(() => _musicVolume = value);
                    AudioService().setMusicVolume(value);
                  },
                  min: 0,
                  max: 1,
                  divisions: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'SFX Volume: ${(_sfxVolume * 100).round()}%',
                   style: TextStyle(fontSize: 24)),
                Slider(
                  thumbColor: Colors.black,
                  activeColor: Colors.black.withAlpha(200),
                  inactiveColor: Colors.black.withAlpha(96),
                  
                  value: _sfxVolume,
                  onChanged: (value) {
                    setState(() => _sfxVolume = value);
                    AudioService().setSFXVolume(value);
                    AudioService().setCardSFXVolume(value);
                  },
                  min: 0,
                  max: 1,
                  divisions: 100,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AudioService().playSFX('touch.wav');
                  },
                  child: const Text('Play SFX'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AudioService().setTheme(GameAudio.mainBackground);
                  },
                  child: const Text('Play Music (if not playing)'),
                ),
              ],
            ),
          ),
        ],   
      ),   
    );
  }
}