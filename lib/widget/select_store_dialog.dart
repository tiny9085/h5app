
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/widget/item/store_item.dart';

import 'confirm_btn.dart';
import 'cus_behavior.dart';

// ignore: must_be_immutable
class SelectStoreDialog extends StatefulWidget {
  final List<StoreEntity> storeList;
  final ValueChanged<StoreEntity> onValueChanged;
  String? selectOrgCode;

  SelectStoreDialog(this.storeList, this.onValueChanged, {this.selectOrgCode});

  @override
  _SelectStoreDialogState createState() => _SelectStoreDialogState();
}

class _SelectStoreDialogState extends State<SelectStoreDialog> {
  StoreEntity? itemChecked;

  @override
  void initState() {
    super.initState();
    if (widget.storeList.isNotEmpty) {
      if (widget.selectOrgCode == null || widget.selectOrgCode!.isEmpty) {
        itemChecked = widget.storeList[0];
      } else {
        for (StoreEntity storeEntity in widget.storeList) {
          if (storeEntity.organCode == widget.selectOrgCode) {
            itemChecked = storeEntity;
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 36.0, right: 36.0),
          decoration: BoxDecoration(
            color: Colors.white,
            //用一个BoxDecoration装饰器提供背景图片
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Positioned(
                      top: 15.0,
                      child: Text("选择店铺", style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontSize: 16.0, color: Color(0xff333333))),
                    ),
                    Positioned(
                      top: 20.0,
                      right: 0.0,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 50.0,
                            height: 20.0,
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "assets/images/ic_close.png",
                              width: 12.0,
                              height: 12.0,
                            ),
                          ),
                          onTap: () {
                            NavigatorUtils.pop(context);
                          }),
                    )
                  ],
                ),
              ),
              Container(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: ScrollConfiguration(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.storeList.length,
                        itemBuilder: (context, index) {
                          StoreEntity store = widget.storeList[index];
                          return StoreItem(
                              code: store.organCode,
                              name: store.organShort,
                              itemChecked: itemChecked!,
                              onChanged: (value) {
                                if (this.itemChecked!.organCode != store.organCode) {
                                  setState(() {
                                    this.itemChecked = store;
                                  });
                                }
                              });
                        }),
                    behavior: CusBehavior(),
                  )),
              ConfirmBtn('确认选择', () {
                widget.onValueChanged(itemChecked!);
                NavigatorUtils.pop(context);
              }),
            ],
          )),
    );
  }
}
