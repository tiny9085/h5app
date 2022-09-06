import 'package:flutter/material.dart';
import 'package:smart_assistant/model/SalesReportResp.dart';

// ignore: must_be_immutable
class StoreRankItem extends StatelessWidget {
  OrganSaleSort? organSaleSort;
  int position;

  StoreRankItem(this.organSaleSort, this.position, {Key? key}) : super(key: key);

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
            height: 92.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organSaleSort?.organName ?? '',
                  style: TextStyle(color: Color(0xFF444444), fontSize: 14.0),overflow: TextOverflow.ellipsis, maxLines: 1
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '销售额',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFFBBBBBB)),
                              ),
                              Text(
                                organSaleSort?.sales?.toString() ?? '',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                '毛利额',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFFBBBBBB)),
                              ),
                              Text(
                                organSaleSort?.grossProfit?.toString() ?? '',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '客流量',
                                style: TextStyle(fontSize: 12.0, color: Color(0xFFBBBBBB)),
                              ),
                              Text(
                                organSaleSort?.guestFlow?.toString() ?? '',
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
