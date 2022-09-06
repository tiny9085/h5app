import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_assistant/widget/cus_behavior.dart';
import 'package:smart_assistant/widget/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyPage extends StatefulWidget {
  static final String sName = "policy";

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // titleText: '隐私政策',
      ),
      body: WebView(
          onProgress: (int progress) {
            // print('WebView is loading (progress : $progress%)');
          },
          javascriptMode: JavascriptMode.unrestricted,
          // initialUrl:"http://192.168.15.55:8089/#/member/privacy?source=h5"
        initialUrl:"http://pharmacy-h5.hnhcyy.com/#/member/privacy?source=h5"
      ),
      // body: ScrollConfiguration(
      //   behavior: CusBehavior(),
      //   child: SingleChildScrollView(
      //     child: Container(
      //       color: Colors.white,
      //       padding: EdgeInsets.all(28.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             '本应用隐私权政策',
      //             style: TextStyle(fontSize: 18.0, color: Color(0xFF333333)),
      //           ),
      //           Text(
      //             '\n\n本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分。'
      //                 '\n\n1.适用范围'
      //                 '\na) 在您注册本应用帐号时，您根据本应用要求提供的个人注册信息；'
      //                 '\n\nb) 在您使用本应用时， 本应用自动接收并记录的您手机上的信息，包括但不限于您的设备号、当前位置、IP地址、操作系统版本、使用的语言、访问日期和时间、软硬件特征信息及您的需求数据；'
      //                 '\n\nc) 本应用为恒昌(上海)信息技术有限公司官方应用，公司通过合法途径取得的用户个人数据以及智能设备相关数据。'
      //                 '\n\n您了解并同意，以下信息不适用本隐私权政策：'
      //                 '\na)您在使用本应用提供的搜索服务时输入的关键字信息；'
      //                 '\n\nb)本应用收集到的您在本应用发布的有关信息数据，包括但不限于参与活动、任务、评价详情等；'
      //                 '\n\nc)违反法律规定或违反本应用规则行为及本应用已对您采取的措施。'
      //                 '\n\n2.信息使用'
      //                 '\na)本应用不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和本应用单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料。'
      //                 '\n\nb)本应用亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播您的个人信息。任何本应用用户如从事上述活动，一经发现，本应用有权立即终止与该用户的服务协议。'
      //                 '\n\nc)为服务用户的目的，本应用可能通过使用您的个人信息，向您提供您感兴趣的信息，包括但不限于向您发出产品和服务信息，或者与本应用合作伙伴共享信息以便他们向您发送有关其产品和服务的信息（后者需要您的事先同意）。'
      //                 '\n\n为了统计分析等目的，我们的产品可能会集成第三方的SDK或其他类似的应用程序等；'
      //                 '\n\n【友盟+】SDK需要收集您设备的国际移动设备识别码（IMEI）、iOS广告标识符（IDFA)、设备Mac地址和设备型号等信息。'
      //                 '\n\n为便于您更好地了解【友盟+】采集的数据类型及用途，以及何保护您的个人信息，您可以登录https://www.umeng.com/policy了解【友盟+】隐私权政策。'
      //                 '\n\n我们需要向TalkingData SDK共享您的相关个人信息的目的、方式和范围等，包括：'
      //                 '\n\n【Android】设备品牌、型号、软件版本等基础信息及其应用列表信息;'
      //                 '\n\n【iOS】设备品牌、型号、软件版本等基础信息;网路信息：设备连接WiFi和基站信息;'
      //                 '\n\n位置信息：设备地理位置;应用信息：SDK宿主应用包名、版本号等信息;'
      //                 '\n\n我们只会使用这些信息进行应用统计分析、作弊防护、推送营销。'
      //                 '\n\n为使您可以更好地了解【TalkingData】收集的数据类型及用途，以及保护个人信息的方式，您可以登录http://www.talkingdata.com/privacy.jsp?languagetype=zh_cn进一步了解【TalkingData】隐私政策。'
      //                 '\n\n同时我们理解并尊重您的选择权，如果您不愿参与【TalkingData】的大数据计算，您也可以通过http://www.talkingdata.com/optout.jsp?languagetype=zh_cn行使opt-out权利。'
      //                 '\n\n您理解并同意，TalkingData有权对已收集的数据进行去标识化和聚合性的处理后构建数据库，用以提供数据服务。'
      //                 '\n\n如果【TalkingData】SDK收集使用个人信息的目的、方式、范围发生变化时，我们会以适当方式通知并提醒终端用户阅读。'
      //                 '\n\n为了您的信息安全，我们已与第三方SDK服务商签署严格数据安全保密协议，这些公司会严格遵守我们的数据隐私和安全要求。除非得到您的同意，我们不会与其共享您的个人身份信息。'
      //                 '\n\n3.信息披露'
      //                 '\n在如下情况下，本应用将依据您的个人意愿或法律的规定全部或部分的披露您的个人信息：'
      //                 '\n\na)经您事先同意，向第三方披露；'
      //                 '\n\nb)为提供您所要求的产品和服务，而必须和第三方分享您的个人信息；'
      //                 '\n\nc)根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；'
      //                 '\n\nd)如您出现违反中国有关法律、法规或者本应用服务协议或相关规则的情况，需要向第三方披露；'
      //                 '\n\ne)如您是适格的知识产权投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；'
      //                 '\n\nf)其它本应用根据法律、法规或者网站政策认为合适的披露。'
      //                 '\n\n4.信息存储和交换'
      //                 '\n本应用收集的有关您的信息和资料将保存在本应用及（或）其关联公司的服务器上，这些信息和资料可能传送至您所在国家、地区或本应用收集信息和资料所在地的境外并在境外被访问、存储和展示。'
      //                 '\n\n5.读写存储与获取地理位置的使用'
      //                 '\na)在您未拒绝接受本应用能够获得本机地理位置、读写存储的情况下，本应用会在您的手机上设定或取用当前地理位置或读写本应用范围内的本地存储，以便您能登录或使用依赖于缓存的本应用服务或功能。'
      //                 '\n\nb)您有权选择接受或拒绝接受本应用获取本机地理位置。您可以通过系统授权设置的方式设置本应用权利。但如果您选择拒绝接受获取本机地理位置，则您可能无法使用涉及定位、测距的本应用服务。'
      //                 '\n\nc)通过本应用所设缓存、当前位置所取得的有关信息，将适用本政策。'
      //                 '\n\n6.相机、录音、读取手机状态权限的使用'
      //                 '\na)在您未拒绝接受本应用能够获得相机、录音、读取手机状态权限的情况下，本应用会在您的手机上打开并使用相机、录音、读取手机状态权限功能，以便您能登录或使用依赖于此类权限的本应用服务或功能，如扫描二维码、语音遥控等。'
      //                 '\n\nb)您有权选择接受或拒绝接受本应用获取相机、录音、读取手机状态权限。您可以通过系统授权设置的方式设置本应用权利。但如果您选择拒绝本应用获取相机、录音、读取手机状态权限，则您可能无法使用涉及扫描二维码、语音遥控等的本应用服务。'
      //                 '\n\nc)通过本应用开启相机、录音、读取手机状态所取得的有关信息，将适用本政策。'
      //                 '\n\n7. 信息安全'
      //                 '\na)本应用帐号均有安全保护功能，请妥善保管您的账号信息。本应用将通过对账号信息进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您注意在信息网络上不存在“完善的安全措施”。'
      //                 '\n\nb)在使用本应用网络服务进行网上交易时，您不可避免的要向交易对方披露自己的个人信息，如联络方式或者手机号码。请您妥善保护自己的个人信息，仅在必要的情形下向他人提供。如您发现自己的个人信息泄密，尤其是本应用用户名及密码发生泄露，请您立即联络本应用客服，以便本应用采取相应措施。\n\n',
      //             style: TextStyle(fontSize: 14.0, color: Color(0xFF666666)),),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
