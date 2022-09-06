import 'package:flutter/material.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/model/StoreEntity.dart';

// ignore: must_be_immutable
class StoreItem extends StatefulWidget {
  String code;
  String name = "";
  StoreEntity itemChecked;

  Function(StoreEntity) onChanged;

  StoreItem({Key? key, required this.code, required this.name, required this.itemChecked, required this.onChanged}) : super(key: key);

  @override
  _StoreItemState createState() => _StoreItemState();
}

class _StoreItemState extends State<StoreItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onChanged(widget.itemChecked);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(widget.code == widget.itemChecked.organCode ? 0xffF6F9FF : 0xfff6f6f6),
          //用一个BoxDecoration装饰器提供背景图片
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        height: 50,
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 6.0),
                child: Image.asset(widget.code == widget.itemChecked.organCode ? 'assets/images/ic_checked.png' : 'assets/images/ic_unchecked.png',
                    width: 17, height: 17)),
            Expanded(
                child: Text(widget.name,
                    maxLines: 2,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                        color: widget.code == widget.itemChecked.organCode ? HCYYColor.primaryColor : HCYYColor.grey_88,
                        fontSize: 14.0)))
          ],
        ),
      ),
    );
  }
}
