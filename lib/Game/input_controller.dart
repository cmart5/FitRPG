import 'package:fit_rpg/Game/Survivor/survivor_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fit_rpg/Game/Survivor/player_component.dart';

class InputController extends Component
with KeyboardHandler, TapCallbacks, DragCallbacks, HasGameReference<SurvivorGame> {

  final PlayerComponent player;

  bool _joystickActive = false;
  Vector2 _joystickCurrent = Vector2.zero();
  
  static const double _bottomMargin = 200;
  static const double _joystickRadius = 60;
  static const double _knobRadius = 30;
  static const double _maxRadius = 120;

  InputController(this.player)
  : super(
    priority: 100,
  );

  Vector2 _joystickBase = Vector2.zero();

  @override
  void onLoad() {
    _joystickBase = Vector2(game.size.x / 2, game.size.y - _joystickRadius - _bottomMargin);
  }

  // Always cover the whole screen so we get every drag.
  @override
  bool containsLocalPoint(Vector2 point) => true;

  //Keyboard
  @override bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Highest Priority: Keyboard
    _joystickActive = false;
    player.setKeyboardMovement(keysPressed);
    return true;
  }

  // Tap/Click
  @override
  void onTapDown(TapDownEvent event) {
    _joystickActive = false;
    final worldPos = event.canvasPosition;
    player.setTouchTarget(worldPos);
  }

  // Drag
  @override
  void onDragStart(DragStartEvent event) {
    _joystickActive = true;
    _joystickBase = event.localPosition;
    _joystickCurrent = _joystickBase;
    player.setKeyboardMovement({});
  }

   @override
  void onDragUpdate(DragUpdateEvent event) {
    final touch = event.canvasEndPosition;
    final delta = touch - _joystickBase;
    final rawDist = delta.length;
    if (rawDist > 0) {
      final dist = rawDist.clamp(0, _maxRadius).toDouble();
      final direction = delta / rawDist;
      _joystickCurrent = _joystickBase + direction * dist;
      final intensity = (dist / _maxRadius).clamp(0.0, 1.0);
      player.setJoystick(direction, intensity);
    } else {
      _joystickCurrent = _joystickBase;
      player.setJoystick(Vector2.zero(), 0);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _joystickActive = false;
    player.setJoystick(Vector2.zero(), 0);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _joystickActive = false;
    player.setJoystick(Vector2.zero(), 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!_joystickActive) return;

    final paintBg = Paint()..color = Colors.black.withAlpha(64);
    final paintKnob = Paint()..color = Colors.white.withAlpha(128);

    // Draw joystick base
    canvas.drawCircle(_joystickBase.toOffset(), _joystickRadius, paintBg);
    // Draw joystick knob
    canvas.drawCircle(_joystickCurrent.toOffset(), _knobRadius, paintKnob);
  }
}