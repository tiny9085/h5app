import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/AppVersionEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        this._version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_logo.png',
                width: 100.0,
                height: 100.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Image.asset(
                  'assets/images/ic_app_name.png',
                  width: 56.0,
                  height: 20.0,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            child: Text(
              '版本号: ${_version == null ? '' : 'V$_version'}',
              style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
            ),
          )
        ],
      ),
      constraints: new BoxConstraints.expand(),
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg_welcome.png'), fit: BoxFit.fill)),
    ));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<GSYState> store = StoreProvider.of(context);
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (SPUtil.getBool('is_not_first_init') ?? false) {
        UserDao.initUserInfo(store).then((res) {
          if (res != null && res.result) {
            NavigatorUtils.goMain(context);
          } else {
            NavigatorUtils.goLogin(context);
          }
          return true;
        });
      } else {
        NavigatorUtils.goGuide(context);
        SPUtil.putBool('is_not_first_init', true);
      }
    });
  }
}
