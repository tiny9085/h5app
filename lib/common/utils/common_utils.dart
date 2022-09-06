import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/widget/AppVersionDialog.dart';
import 'package:smart_assistant/widget/select_store_dialog.dart';
import 'package:smart_assistant/widget/show_privacy_policy_dialog.dart';
import 'navigator_utils.dart';
import "package:intl/intl.dart";

class CommonUtils {
  static double? getPercent(var dividend, var divider) {
    if (dividend == null || divider == 0) return 0.0;
    double? result = NumUtil.divide(double.parse(dividend.toString()), divider);
    result = double.tryParse(CommonUtils.moneyFormat(result));
    return result;
  }

  static formatPercent(var dividend, var divider) {
    double? result = getPercent(dividend, divider);
    if (result == null) {
      return '-';
    } else {
      return '$result%';
    }
  }

  static oneHundredFormatPercent(var dividend, var divider) {
    double? result = getPercent(dividend, divider);
    if (result == null) {
      return '-';
    } else {
      return '${moneyFormat(100 * result)}%';
    }
  }

  static formatPercentValue(var dividend, var divider) {
    double? result = getPercent(dividend, divider);
    if (result == null || result == 0) {
      return '-';
    } else if (result > 0) {
      return '+$result%';
    } else if (result < 0) {
      return '$result%';
    }
  }

  /// double 显示金额格式
  static moneyFormat(double money) {
    NumberFormat format = new NumberFormat("0.00");
    return format.format(money);
  }

  static fetchCurrentDate() {
    DateTime dateTime = DateTime.now();
    String formatTime = formatDate(dateTime, [yyyy, '-', mm, '-', dd,' ',HH,':',nn,':',ss]);
    return formatTime;
  }

  static getThemeData(MaterialColor color) {
    return ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, primarySwatch: color, platform: TargetPlatform.android);
  }

  static Future<Null> showStoreListDialog(BuildContext context, List<StoreEntity> stores, ValueChanged<StoreEntity> onValueChanged, {String? selectOrgCode}) {
    return NavigatorUtils.showCommonDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectStoreDialog(stores, onValueChanged, selectOrgCode: selectOrgCode);
        });
  }

  static Future<Null> showPrivacyPolicyDialog(BuildContext context, ) {
    return NavigatorUtils.ShowPrivacyPolicyDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowPrivacyPolicyDialog();
        });
  }

  static Future<Null> showVersionUpdateDialog(BuildContext context, String content, bool isForceUpdate, String downloadUrl) {
    return NavigatorUtils.showCommonDialog(
        context: context,
        builder: (BuildContext context) {
          return AppVersionDialog(content, isForceUpdate, downloadUrl);
        });
  }

  static Future<Null> showConfirmDialog(BuildContext context, String content, VoidCallback onPressed) {
    return NavigatorUtils.showCommonDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: 145.0,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(content),
                    height: 100.0,
                  ),
                  Divider(height: 1.0, color: Color(0xffe4e4e4)),
                  Container(
                    height: 44.0,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                '取消',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                NavigatorUtils.pop(context);
                              }),
                          flex: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              alignment: Alignment.center,
                              constraints: new BoxConstraints.expand(),
                              child: Text(
                                '确定',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xff9566FF),
                                    Color(0xff69BEFF),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0)),
                              ),
                            ),
                            onTap: onPressed,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
