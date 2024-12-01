import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/account_api.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/pages/setting/info_account_setting_page.dart';
import 'package:flutter_app/resources/widgets/gradient_appbar.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SettingPage extends NyStatefulWidget {
  static const path = '/setting_page';
  SettingPage({Key? key}) : super(path, key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends NyState<SettingPage> {
  bool _loading = true;
  User? _account;
  @override
  initState() {
    super.initState();
    fetchAccountInfo();
  }

  Future fetchAccountInfo() async {
    try {
      User account =
          await myApi<AccountApi>((request) => request.infoAccount());
      _account = account;
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
        '',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              routeTo(
                InfoSettingPage.path,
                data: _account,
                onPop: (value) {
                  fetchAccountInfo();
                },
              );
            },
            child: ListTile(
              title: Text('Sửa thông tin'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
