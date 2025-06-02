import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class BattleScene extends FlameGame {
  late SpriteComponent knight;
  late SpriteComponent boss;

  // Reference for animation
  void playTackleAnimation() {
    final originalPos = knight.position.clone();
    final attackTarget = boss.position.clone()..x -= 30;

    knight.add(
      MoveEffect.to(
        attackTarget,
        EffectController(duration: 0.2, reverseDuration: 0.2),
        onComplete: () => flashBoss(),
      ),
    );
  }

  void playTackleAnimationEnemy() {
    final originalPos = boss.position.clone();
    final attackTarget = knight.position.clone()..x += 30;

    boss.add(
      MoveEffect.to(
        attackTarget,
        EffectController(duration: 0.2, reverseDuration: 0.2),
        onComplete: () => flashKnight(),
      ),
    );
  }

  void flashBoss() {
    boss.add(
      SequenceEffect(
        [
          OpacityEffect.to(0.0, EffectController(duration: 0.1)),
          OpacityEffect.to(1.0, EffectController(duration: 0.1)),
          OpacityEffect.to(0.0, EffectController(duration: 0.1)),
          OpacityEffect.to(1.0, EffectController(duration: 0.1)),
        ],
      ),
    );
  }

  void flashKnight() {
    knight.add(
      SequenceEffect(
        [
          OpacityEffect.to(0.0, EffectController(duration: 0.1)),
          OpacityEffect.to(1.0, EffectController(duration: 0.1)),
          OpacityEffect.to(0.0, EffectController(duration: 0.1)),
          OpacityEffect.to(1.0, EffectController(duration: 0.1)),
        ],
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    final backgroundSprite = await loadSprite('BattleScene_BG.png');
    final knightSprite = await loadSprite('WarriorSprite.png');
    final bossSprite = await loadSprite('BossSprite.png');

    final screenCenterY = size.y / 2;

    final background = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = size;

    knight = SpriteComponent()
      ..sprite = knightSprite
      ..size = Vector2(140, 200)
      ..position = Vector2(size.x * 0.1, screenCenterY + 50);

    boss = SpriteComponent()
      ..sprite = bossSprite
      ..size = Vector2(200, 250)
      ..position = Vector2(size.x * 0.5, screenCenterY - 150);

    addAll([background, knight, boss]);
  }
}

class BattleSceneWidget extends StatefulWidget {
  const BattleSceneWidget({super.key, required this.onGameReady});

  final void Function(BattleScene) onGameReady;

  @override
  State<BattleSceneWidget> createState() => _BattleSceneWidgetState();
}

class _BattleSceneWidgetState extends State<BattleSceneWidget> {
  late BattleScene game;

  @override
  void initState() {
    super.initState();
    game = BattleScene();
    widget.onGameReady(game);
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}