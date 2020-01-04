import 'package:dartin/dartin.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/common.dart';

class CommonRepository extends BaseRepository {
  final CommonService _commonService = inject();

  Future<VerifyCode> getVerifyCode() async =>
      (await _commonService.getVerifyCode()).body.result;
}
