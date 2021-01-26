import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key key,
      @required this.height,
      @required this.btnText,
      @required this.btnColor,
      @required this.textColor,
      @required this.isFontBold,
      @required this.borderColor})
      : super(key: key);

  final double height;
  final String btnText;
  final Color textColor;
  final Color btnColor;
  final bool isFontBold;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height * 0.12,
      decoration: BoxDecoration(
        color: btnColor,
        border: Border.all(color: borderColor, width: 0.4),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          color: textColor,
          fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
          fontSize: height * 0.04,
        ),
      ),
    );
  }
}
