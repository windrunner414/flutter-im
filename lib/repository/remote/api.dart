import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';

part 'api.g.dart';
part 'api_server.dart';
part 'http.dart';
