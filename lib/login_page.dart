import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/controller.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/login_api.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/resources/widgets/gradient_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginPage extends NyStatefulWidget {
  final Controller controller = Controller();

  static const path = '/login_page';

  LoginPage({Key? key}) : super(path, key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends NyState<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _loading = false;
  bool _isPasswordVisible = false;
  _login() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final payload = {
      'email': _formKey.currentState!.value['email'],
      'password': _formKey.currentState!.value['password'],
    };

    try {
      User user = await myApi<AccountApi>((request) => request.login(payload));
      log(user.toJson().toString());
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          'Đăng nhập',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: context.color.primaryAccent),
                ),
                12.verticalSpace,
                FormBuilderTextField(
                  name: 'email',
                  cursorColor: context.color.primaryAccent,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                      labelText: 'Tài khoản',
                      hintText: 'Nhập tài khoản',
                      floatingLabelStyle: TextStyle(
                        color: context.color.primaryAccent,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.color.primaryAccent,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.color.primaryAccent,
                        ),
                      )),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'password',
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: context.color.primaryAccent,
                  obscureText: !_isPasswordVisible,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    floatingLabelStyle: TextStyle(
                      color: context.color.primaryAccent,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.color.primaryAccent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.color.primaryAccent,
                      ),
                    ),
                    suffix: GestureDetector(
                      onTap: _togglePasswordVisibility,
                      child: Icon(
                        _isPasswordVisible
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.solidEye,
                        color: Colors.black26,
                        size: 18,
                      ),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                SizedBox(height: 20),
                InkWell(
                  child: Text(
                    'Quên mật khẩu',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: context.color.primaryAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.white),
                            onPressed: () {
                              _login();
                            },
                            child: _loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("Đăng nhập"))),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
