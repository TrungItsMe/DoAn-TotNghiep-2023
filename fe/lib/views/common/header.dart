// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:fe/config.dart';
import 'package:fe/models/user.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../controllers/api.dart';
import '../../controllers/provider.dart';
import '../change-password.dart';
import '../screen-app/app-quan-tri/quan-ly-nhan-vien/xem-nv.dart';
import 'footer.dart';
import 'loadApi.dart';
import 'style.dart';

class Header extends StatefulWidget {
  final Widget widgetBody;
  const Header({Key? key, required this.widgetBody}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  User userLogin = User();
  bool statusInfo = false;
  bool showMenu = true;
  int sttPage = 0;

  var appBarHeight = AppBar().preferredSize.height;
  LocalStorage storage = LocalStorage("storage");
  String? id;
  String? role;
  String name = "";
  caillInfo() async {
    role = storage.getItem("role");
    id = storage.getItem("id");
    await callUser();
    setState(() {
      statusInfo = true;
    });
  }

  callUser() async {
    var securityModel = Provider.of<SecurityModel>(context, listen: false);
    var responseUser = await httpGet("/api/nguoi-dung/get/$id", context);
    var bodyUser = jsonDecode(responseUser['body']);
    userLogin = User.fromJson(bodyUser['result']);
    List<String> listName = userLogin.fullName!.split(" ");
    name = listName.last;
    securityModel.changeUser(userLogin);
  }

  @override
  void initState() {
    super.initState();
    caillInfo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Material(child: Consumer<SecurityModel>(builder: (context, user, child) {
      return (statusInfo)
          ? Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (showMenu)
                      ? Container(
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0, color: Color(0xffDADADA)),
                            color: mainColor,
                          ),
                          child: (role == "0")
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 0) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/trang-chu');
                                            setState(() {
                                              user.changeSttMenu(0);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: (user.getSttPage() == 0) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Trang chủ".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 0) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 5) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/quan-ly-ca-truc');
                                            setState(() {
                                              user.changeSttMenu(5);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.receipt_long,
                                                color: (user.getSttPage() == 5) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Quản lý ca trực".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 5) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 1) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/quan-ly-ve');
                                            setState(() {
                                              user.changeSttMenu(1);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.confirmation_number,
                                                color: (user.getSttPage() == 1) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Quản lý vé".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 1) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 6) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/quan-ly-xe-luu-bai');
                                            setState(() {
                                              user.changeSttMenu(6);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.motorcycle,
                                                color: (user.getSttPage() == 6) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Quản lý xe lưu bãi".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 6) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 2) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/quan-ly-nhan-vien');
                                            setState(() {
                                              user.changeSttMenu(2);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.group,
                                                color: (user.getSttPage() == 2) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Quản lý nhân viên".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 2) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 3) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/quan-ly-bai-xe');
                                            setState(() {
                                              user.changeSttMenu(3);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.local_parking,
                                                color: (user.getSttPage() == 3) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Quản lý bãi gửi xe".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 3) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 10) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/ca-truc-nv');
                                            setState(() {
                                              user.changeSttMenu(10);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: (user.getSttPage() == 10) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Ca trực".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 10) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 11) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/dang-ky-the');
                                            setState(() {
                                              user.changeSttMenu(11);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add_card,
                                                color: (user.getSttPage() == 11) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 11),
                                              Text(
                                                "đăng ký vé".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 11) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                      Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 13) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/lich-su-dang-ky-ve');
                                            setState(() {
                                              user.changeSttMenu(13);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.history,
                                                color: (user.getSttPage() == 13) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 11),
                                              Text(
                                                "Lịch sử đăng ký vé".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 13) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: (user.getSttPage() == 12) ? white : mainColor, borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/xe-luu-bai-nv');
                                            setState(() {
                                              user.changeSttMenu(12);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.motorcycle,
                                                color: (user.getSttPage() == 12) ? mainColor : white,
                                                size: 28,
                                              ),
                                              SizedBox(width: 11),
                                              Text(
                                                "Xe lưu bãi".toUpperCase(),
                                                style: TextStyle(color: (user.getSttPage() == 12) ? mainColor : white, fontSize: 15, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          )),
                                    ),
                                     
                                  ],
                                ))
                      : Container(),
                  Container(
                    width: (showMenu) ? width - 300 : width,
                    decoration: BoxDecoration(color: colorPage),
                    child: widget.widgetBody,
                  )
                ],
              ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: mainColor,
                      ),
                    ),
                    color: Color.fromARGB(0, 242, 242, 242),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 229, 229, 229).withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Custom drawer icon
                      AppBar(
                        automaticallyImplyLeading: false,
                        leading: Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: Icon(
                                !showMenu ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                                size: 22,
                                color: mainColor, // Change Custom Drawer Icon Color
                              ),
                              onPressed: () {
                                showMenu = !showMenu;
                                setState(() {});
                              },
                              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                            );
                          },
                        ),
                        backgroundColor: Colors.transparent, // 1
                        elevation: 0,
                        title: Row(
                          children: [
                            Image.asset(
                              "/images/logo-ngang.webp",
                              width: 230,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          // MenuPopupTest(),
                          SizedBox(
                            width: 20,
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Thông tin cá nhân',
                            offset: Offset(0.0, 65),
                            child: SizedBox(
                              width: size.width * 0.12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (user.user.avatar==null||user.user.avatar=="")
                                  ?ClipOval(
                                      child: Image.asset(
                                    "/images/noavatar.png",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )):ClipOval(
                                      child: Image.network(
                                    "$baseUrl/api/files/${user.user.avatar}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                child: Container(
                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                                          minimumSize: Size(50, 30),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${user.user.fullName}",
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => XemNVScreen(
                                                    data: user.user,
                                                  ));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Quyền:',
                                                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                                                )),
                                            Expanded(flex: 5, child: Text((role == "0") ? "ADMIN" : "Nhân viên", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Color.fromARGB(235, 209, 209, 209)), child: Icon(Icons.key)),
                                  contentPadding: const EdgeInsets.all(0),
                                  hoverColor: Colors.transparent,
                                  title: const Text(
                                    'Đổi mật khẩu',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: (() {
                                    showDialog(context: context, builder: (BuildContext context) => ChangePassword());
                                  }),
                                ),
                                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Color.fromARGB(235, 209, 209, 209)), child: Icon(Icons.logout)),
                                  contentPadding: const EdgeInsets.all(0),
                                  hoverColor: Colors.transparent,
                                  title: const Text(
                                    'Đăng xuất',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: (() {
                                    Navigator.pushNamed(context, '/login');
                                  }),
                                ),
                                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
          : CommonApp().loadingCallAPi();
    }));
  }
}
