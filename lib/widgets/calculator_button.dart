
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(this.text, this.click);

  final String text;
  final Function click;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
