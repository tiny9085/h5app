import 'package:flutter/material.dart';

class ConfirmBtn extends StatefulWidget {
  String label;
  VoidCallback onPressed;

  ConfirmBtn(this.label, this.onPressed);

  @override
  _ConfirmBtnState createState() => _ConfirmBtnState();
}

class _ConfirmBtnState extends State<ConfirmBtn> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        margin: EdgeInsets.only(top:14.0,left: 16.0,right: 16.0,bottom: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              enabled ? Color(0x409566FF) : Color(0xff9566FF),
              enabled ? Color(0x4069BEFF) : Color(0xff69BEFF),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontSize: 16.0, color: Colors.white),
        ),
      ),
      onTapDown: (TapDownDetails details) {
        setState(() {
          enabled = true;
        });
      },
      onTapCancel: () {
        setState(() {
          enabled = false;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          enabled = false;
        });
      },
      onTap: widget.onPressed,
    );
  }
}
