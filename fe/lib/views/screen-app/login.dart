// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../controllers/api.dart';
import '../../controllers/provider.dart';
import '../common/toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LocalStorage storage = LocalStorage("storage");
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // hien pass
  bool isHiddenPassword = true;
  void _passwordView() {
    if (isHiddenPassword == true) {
      isHiddenPassword = false;
    } else {
      isHiddenPassword = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool checkSubmitButton() {
    if (_usernameController.text.isNotEmpty && _usernameController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Center(child: const CircularProgressIndicator());
        },
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("/images/4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: 500,
            width: 400,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color.fromARGB(255, 238, 238, 238),borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        margin: EdgeInsets.only(bottom: 30),
                        child: ClipOval(child: Image.asset("/images/logo.jpeg")),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Phần mềm quản lý trông xe'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: -0.8,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 6, 6, 6),
                            ),
                            textAlign: TextAlign.center,
                          )),
                      Text(
                        'ĐẠI HỌC CÔNG NGHIỆP HÀ NỘI',
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: -0.8,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Form(
                        child: AutofillGroup(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: SizedBox(
                                    width: 400,
                                    height: 50,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [AutofillHints.email],
                                      controller: _usernameController,
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                        border: OutlineInputBorder(),
                                        labelText: 'Tài khoản',
                                        hintText: 'Nhập tên đăng nhập',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: SizedBox(
                                    width: 400,
                                    height: 50,
                                    child: TextFormField(
                                      autofillHints: const [AutofillHints.password],
                                      controller: _passwordController,
                                      obscureText: isHiddenPassword,
                                      onFieldSubmitted: (value) {},
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(),
                                        labelText: 'Mật khẩu',
                                        hintText: 'Nhập mật khẩu',
                                        suffixIcon: InkWell(
                                          onTap: _passwordView,
                                          child: isHiddenPassword ? Icon(Icons.visibility_off_outlined) : Icon(Icons.visibility),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: ElevatedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: const Text('Đăng nhập'),
                                        ),
                                        onPressed: () async {
                                          // var securityModel = Provider.of<SecurityModel>(context, listen: false);
                                          // Navigator.pushNamed(context, '/trang-chu');
                                          // securityModel.changeSttMenu(0);
                                          processing();
                                          if (_usernameController.text == "" || _passwordController.text == "") {
                                            showToast(
                                              context: context,
                                              msg: "Cần điền đầy đủ thông tin",
                                              color: Color.fromRGBO(245, 117, 29, 1),
                                              icon: const Icon(Icons.warning),
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            var loginData = {"userName": _usernameController.text, "password": _passwordController.text};
                                            var responseLogin = await httpPost("/api/nguoi-dung/login", loginData, context);
                                            var body = jsonDecode(responseLogin['body']);
                                            if (body['success'] == false) {
                                              showToast(
                                                context: context,
                                                msg: "${body['result']}",
                                                color: Color.fromRGBO(245, 117, 29, 1),
                                                icon: const Icon(Icons.warning),
                                              );
                                              Navigator.pop(context);
                                            } else {
                                              if (body["result"]['status'] == 1) {
                                                storage.setItem('id', body["result"]['id'].toString());
                                                storage.setItem('role', body["result"]['role'].toString());
                                                var securityModel = Provider.of<SecurityModel>(context, listen: false);
                                                if (body["result"]['role'] == 0) {
                                                  Navigator.pushNamed(context, '/trang-chu');
                                                  securityModel.changeSttMenu(0);
                                                } else if (body["result"]['role'] == 1) {
                                                  Navigator.pushNamed(context, '/ca-truc-nv');
                                                  securityModel.changeSttMenu(10);
                                                }
                                              } else {
                                                showToast(
                                                  context: context,
                                                  msg: "Tài khoản không hoạt động",
                                                  color: Colors.orange,
                                                  icon: const Icon(Icons.warning),
                                                );
                                                Navigator.pop(context);
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
