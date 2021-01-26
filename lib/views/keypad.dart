import 'package:calculator/models/keys.dart';
import 'package:calculator/views/calculator_key.dart';
import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  //final bool isDark;

  const KeyPad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        getCalculatorSymbols(
            [Keys.clear, Keys.sign, Keys.percent, Keys.add], height),
        getCalculatorSymbols(
            [Keys.one, Keys.two, Keys.three, Keys.subtract], height),
        getCalculatorSymbols(
            [Keys.four, Keys.five, Keys.six, Keys.multiply], height),
        getCalculatorSymbols(
            [Keys.seven, Keys.eight, Keys.nine, Keys.divide], height),
        getCalculatorSymbols([Keys.zero, Keys.decimal, Keys.equals], height)
      ],
    );
  }

  Widget getCalculatorSymbols(List<dynamic> calculatorKeys, double height) {
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < calculatorKeys.length; i++) {
      list.add(CalculatorKey(
        symbol: calculatorKeys[i],
      ));
    }
    return new Row(children: list);
  }
}
