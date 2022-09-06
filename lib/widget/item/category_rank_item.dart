import 'package:flutter/material.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/model/SalesReportResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';

// ignore: must_be_immutable
class CategoryRankItem extends StatelessWidget {
  CategorySort? _categorySort;
  int position;

  CategoryRankItem(this._categorySort, this.position, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      // behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              //用一个BoxDecoration装饰器提供背景图片
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 12.0),
            margin: EdgeInsets.only(top: 12.0),
            height: 67.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_categorySort?.categoryName ?? '', style: TextStyle(color: Color(0xFF444444), fontSize: 14.0),overflow: TextOverflow.ellipsis, maxLines: 1),
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text(
                              '销售金额',
                              style: TextStyle(fontSize: 12.0, color: Color(0xFFBBBBBB)),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10.0),),
                            Text(
                              _categorySort?.sales?.toString() ?? '',
                              style: TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                '销售占比',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFFBBBBBB)),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.0),),
                              Text(
                                CommonUtils.oneHundredFormatPercent(_categorySort?.sales, _categorySort?.salesTotal),
                                style: TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            child: Image.asset(
              'assets/images/ic_rank_${position + 1}.png',
              width: 36.0,
              height: 36.0,
            ),
            top: 12.0,
          )
        ],
      ),
    );
  }
}
