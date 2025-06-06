import 'package:flutter/material.dart';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

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
            padding: EdgeInsets.all(24.w), 
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Settings',
                  style: TextStyle(fontSize: 48.sp),
                ),
                Text(
                  'Music Volume: ${(_musicVolume * 100).round()}%',
                  style: TextStyle(fontSize: 24.sp),
                ),
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
                SizedBox(height: 20.h),
                Text(
                  'SFX Volume: ${(_sfxVolume * 100).round()}%',
                  style: TextStyle(fontSize: 24.sp),
                ),
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
                SizedBox(height: 20.h), 
                ElevatedButton(
                  onPressed: () {
                    AudioService().playSFX('touch.wav');
                  },
                  child: Text(
                    'Play SFX',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    AudioService().setTheme(GameAudio.mainBackground);
                  },
                  child: Text(
                    'Play Music (if not playing)',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ],   
      ),   
    );
  }
}