import 'package:clone_zay_chin/data_models/auth.dart';
import 'package:flutter/material.dart';

void performLogin(BuildContext context, AuthModel authModel) async {
  var token = await Navigator.of(context).pushNamed('/auth') as String?;
  if (token != null) {
    authModel.saveToken(token);
  }
}
