import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/account_api.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/pages/setting/info_account_setting_page.dart';
import 'package:flutter_app/resources/widgets/gradient_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    ScreenUtil.init(context);
    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
        '',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              Divider(
                color: Colors.grey[200],
              ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: buildAvatar(context),
                            ),
                            10.horizontalSpace,
                            Text(
                              _account!.name ?? '',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  )),
              Divider(
                color: Colors.grey[200],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _account?.avatar != null
              ? NetworkImage(_account!.avatar!)
              : AssetImage('public/assets/images/placeholder.jpg')
                  as ImageProvider,
          onBackgroundImageError: (_, __) {
            setState(() {});
          },
          child: null,
        ),
      ],
    );
  }
}
