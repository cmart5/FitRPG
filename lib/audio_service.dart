import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameAudio{
  mainBackground,
  battleBackground,
}

//Singleton service to manage audio playback
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  double musicVolume = 0.5;
  double sfxVolume = 0.5;

  GameAudio? _currentTheme;

  Future<void> setTheme(GameAudio theme) async {

    if(_currentTheme == theme && _bgmPlayer.playing) {
      return; // If the theme is already set and playing, do nothing
    }

    _currentTheme = theme;

    switch (theme) {
      case GameAudio.mainBackground:
      print("🎵 Loading main_background.wav");
      await _bgmPlayer.setAsset('assets/music/main_background.wav');
      break;

      case GameAudio.battleBackground:
      print("🎵 Loading battle_background.wav");
      await _bgmPlayer.setAsset('assets/music/battle_background.wav');
      break;
    }

    _bgmPlayer.setLoopMode(LoopMode.one);
    await _bgmPlayer.play();
    print("✅ Music playback started");
  }

  
  Future<void> playSFX(String soundFile) async {
    await _sfxPlayer.setAsset('assets/sounds/$soundFile');
    _sfxPlayer.setLoopMode(LoopMode.off); // Ensure SFX does not loop
    _sfxPlayer.play();
    print("✅ SFX playback started: $soundFile");
  }

  Future<void> playCardSFX(String soundFile) async {
    try {
      final player = AudioPlayer(); // Create a new temporary player
      await player.setAsset('assets/sounds/$soundFile');
      await player.setVolume(sfxVolume);
      await player.play();

      // Dispose after playback completes
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (e) {
      print("❌ Error playing SFX: $e");
    }
  }

  Future<void> setMusicVolume(double volume) async {
    musicVolume = volume;
    _bgmPlayer.setVolume(volume);
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('musicVolume', volume);
  }

  Future<void> setSFXVolume(double volume) async {
    sfxVolume = volume;
    _sfxPlayer.setVolume(volume);
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('sfxVolume', volume);
  }
}