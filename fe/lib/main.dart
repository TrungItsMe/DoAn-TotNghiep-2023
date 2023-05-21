import 'package:fe/views/common/header.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'controllers/provider.dart';
import 'views/screen-app/app-nhan-vien/ca-truc/ca-truc-nv.dart';
import 'views/screen-app/app-nhan-vien/dang-ky-the/dang-ky-the.dart';
import 'views/screen-app/app-nhan-vien/lich-su-dang-ky-ve/lich-su-ve.dart';
import 'views/screen-app/app-nhan-vien/xe-luu-bai/xe-luu-bai-nv.dart';
import 'views/screen-app/app-quan-tri/quan-lu-bai-gui-xe/quan-ly-bai-gui-xe.dart';
import 'views/screen-app/app-quan-tri/quan-ly-ca-truc/quan-ly-ca-truc.dart';
import 'views/screen-app/app-quan-tri/quan-ly-nhan-vien/quan-ly-nhan-vien.dart';
import 'views/screen-app/app-quan-tri/quan-ly-ve/quan-ly-ve-screen.dart';
import 'views/screen-app/app-quan-tri/quan-ly-xe-luu-bai/quan-ly-xe-luu-bai.dart';
import 'views/screen-app/app-quan-tri/trang-chu/trang-chu.dart';
import 'views/screen-app/login.dart';

void main() async {
  var securityModel = SecurityModel(LocalStorage('storage'));
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => securityModel),
        ],
        child: MaterialApp(
            title: 'Quản lý trông xe',
            routes: {
              '/login': (context) => LoginScreen(),
              '/trang-chu': (context) => const TrangChuScreen(),
              '/quan-ly-bai-xe': (context) => const QuanLyBaiXeScreen(),
              '/quan-ly-nhan-vien': (context) => const QuanNhanVienScreen(),
              '/quan-ly-ca-truc': (context) => const QLCaTrucScreen(),
              '/ca-truc-nv': (context) => const CaTrucNVScreen(),
              '/dang-ky-the': (context) => const DangKyTheScreen(),
              '/quan-ly-ve': (context) => const QuanLyVeScreen(),
              '/quan-ly-xe-luu-bai': (context) => const QuanXeLuuBaiScreen(),
              '/lich-su-dang-ky-ve': (context) => const LichSuVeScreen(),
              '/xe-luu-bai-nv': (context) => const QuanXeLuuBaiNVScreen(),
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: const Locale('vi'),
            home: LoginScreen())),
  );
}
