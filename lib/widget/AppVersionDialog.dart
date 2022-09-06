import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionDialog extends StatefulWidget {

  String content;
  bool isForceUpdate;
  String downloadUrl;

  AppVersionDialog(this.content, this.isForceUpdate, this.downloadUrl);

  @override
  _AppVersionDialogState createState() => _AppVersionDialogState();

}

class _AppVersionDialogState extends State<AppVersionDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 38.0, right: 38.0, bottom: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: ListView(
          shrinkWrap:true,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !widget.isForceUpdate,
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    width: 36,
                    height: 36,
                  ),
                ),
                Expanded(
                    child: Text('新版本更新', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),)
                ),
                Visibility(
                  visible: !widget.isForceUpdate,
                  child: InkWell(
                    onTap: () {
                      UserDao.setDisableUpdateDate(DateTime.now().toString());//关掉后，一天都不再提示。
                      NavigatorUtils.pop(context);//关闭弹窗
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.all(10),
                        width: 36,
                        height: 36,
                        child: Image.asset('assets/images/ic_close.png',)
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 24),
                child: Text(
                  widget.content,
                  style: TextStyle(color: Color(0xFF666666), fontSize: 15, fontWeight: FontWeight.normal, ),
                ),
              ),
            ),
            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      margin: EdgeInsets.only(left: 36,right: 36,bottom: 16),
                      child: Center(
                        child: Text(
                          '立即更新',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0, color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF9566FF),
                              Color(0xFF69BEFF),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(44.0))
                      ),
                    ),
                  )
                ],
              ),
              onTap: () async {
                if (!await launchUrl(Uri.parse(widget.downloadUrl))) {
                  throw 'Could not launch ${widget.downloadUrl}';
                }
              },
            )
          ],
        ),
      ),
    );
  }

}