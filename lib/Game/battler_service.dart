import 'package:flutter/material.dart';

class BattleMenu extends StatefulWidget {
  final void Function(String) onCommandSelected;

  const BattleMenu({super.key, required this.onCommandSelected});

  @override
  State<BattleMenu> createState() => _BattleMenuState();
}

class _BattleMenuState extends State<BattleMenu> {
  String? subMenu; 

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons;

    if(subMenu == 'attack') {
      buttons = [
        _menuButton('Normal Attack'),
        _menuButton('Special Attack'),
        _backButton(),
      ];
    } else {
      buttons = [
        _menuButton('Attack', subMenuTrigger: 'attack'),
        _menuButton('Magic/Skills(X)'),
        _menuButton('Inventory(X)'),
        _menuButton('Run'),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }

  Widget _menuButton(String label, {String? subMenuTrigger}) {
  // Example: match labels to icons
  IconData icon = Icons.touch_app;
  if (label.contains('Attack')) icon = Icons.gavel;
  if (label.contains('Inventory')) icon = Icons.backpack;
  if (label.contains('Run')) icon = Icons.directions_run;
  if (label.contains('Magic')) icon = Icons.auto_awesome;

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 60, 140, 210),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          if (subMenuTrigger != null) {
            setState(() => subMenu = subMenuTrigger);
          } else {
            widget.onCommandSelected(label);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _backButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
          ),
          onPressed: () => setState(() => subMenu = null),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back, size: 20),
                SizedBox(width: 6),
                Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'pixelFont',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BattleMenuContainer extends StatelessWidget {
  final void Function(String) onCommandSelected;

  const BattleMenuContainer({super.key, required this.onCommandSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black.withAlpha(180),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: BattleMenu(onCommandSelected: onCommandSelected),
    );
  }
}