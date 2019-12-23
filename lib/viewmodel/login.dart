import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/viewmodel/base.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepository = inject();
  BehaviorSubject<VerifyCode> _verifyCodeSubject = BehaviorSubject();
  Stream<VerifyCode> get verifyCodeStream => _verifyCodeSubject.stream;

  String username;
  String password = "";
  String verifyCode = "";

  Future<void> refreshVerifyCode() async {
    _verifyCodeSubject.add(null);
    try {
      _verifyCodeSubject.add(await _authRepository.getVerifyCode());
    } catch (e) {
      _verifyCodeSubject.addError(e);
    }
  }

  @override
  void init() {
    username = ""; // TODO:保存用户名
    refreshVerifyCode();
  }

  @override
  void dispose() {
    _verifyCodeSubject.close();
  }
}
